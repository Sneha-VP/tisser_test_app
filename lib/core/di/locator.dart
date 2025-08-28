import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../repositories/item_repository.dart';
import '../../services/api_services.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  final prefs = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => prefs);

  locator.registerLazySingleton<ApiService>(() => ApiService());
  locator.registerLazySingleton<ItemRepository>(() => ItemRepository(apiService: locator<ApiService>(), prefs: locator<SharedPreferences>()));
}
