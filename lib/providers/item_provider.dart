import 'package:flutter/material.dart';
import '../repositories/item_repository.dart';
import '../models/item_model.dart';

enum LoadingState { idle, loading, success, error }

class ItemProvider extends ChangeNotifier {
  final ItemRepository repository;

  List<ItemModel> _items = [];
  LoadingState _state = LoadingState.idle;
  String? _error;

  List<ItemModel> get items => _items;
  LoadingState get state => _state;
  String? get error => _error;

  ItemProvider({required this.repository});

  Future<void> loadItems({bool forceRefresh = false}) async {
    _state = LoadingState.loading;
    _error = null;
    notifyListeners();
    try {
      _items = await repository.getItems(forceRefresh: forceRefresh);
      _state = LoadingState.success;
      // ensure cache updated
      await repository.saveItemsToCache(_items);
    } catch (e) {
      _error = e.toString();
      _state = LoadingState.error;
    }
    notifyListeners();
  }

  ItemModel? getById(int id) {
    try {
      return _items.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  void addItem(ItemModel item) {
    _items.insert(0, item);
    repository.saveItemsToCache(_items);
    notifyListeners();
  }

  void updateItem(ItemModel item) {
    final idx = _items.indexWhere((i) => i.id == item.id);
    if (idx != -1) {
      _items[idx] = item;
      repository.saveItemsToCache(_items);
      notifyListeners();
    }
  }

  void deleteItem(int id) {
    _items.removeWhere((i) => i.id == id);
    repository.saveItemsToCache(_items);
    notifyListeners();
  }
}
