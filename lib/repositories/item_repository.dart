import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item_model.dart';
import '../services/api_services.dart';

class ItemRepository {
  final ApiService apiService;
  final SharedPreferences prefs;
  static const String cacheKey = 'cached_items';

  ItemRepository({required this.apiService, required this.prefs});

  Future<List<ItemModel>> getItems({bool forceRefresh = false}) async {
    // If no network or not forcing, try cache
    if (!forceRefresh) {
      final cached = prefs.getString(cacheKey);
      if (cached != null) {
        try {
          final List<dynamic> arr = jsonDecode(cached);
          return arr.map((e) => ItemModel.fromMap(e as Map<String, dynamic>)).toList();
        } catch (_) {
          // fallthrough to network
        }
      }
    }

    // Fetch from network
    final raw = await apiService.fetchItems();
    // Map to ItemModel - map jsonplaceholder fields
    final List<ItemModel> items = raw.map((map) {
      final transformed = {
        'id': map['id'],
        'title': map['title'],
        'description': map['body'],
        // create random status: even -> completed, odd -> pending
        'status': ((map['id'] ?? 0) % 2 == 0) ? 'completed' : 'pending',
        'createdDate': DateTime.now().toIso8601String(),
      };
      return ItemModel.fromMap(transformed);
    }).toList();

    // cache
    prefs.setString(cacheKey, jsonEncode(items.map((e) => e.toMap()).toList()));
    return items;
  }

  Future<void> saveItemsToCache(List<ItemModel> items) async {
    prefs.setString(cacheKey, jsonEncode(items.map((e) => e.toMap()).toList()));
  }
}
