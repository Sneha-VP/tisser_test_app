import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tisser_test/routes/app_routs.dart';
import 'package:tisser_test/services/api_services.dart';
import 'core/di/locator.dart' as di;
import 'providers/auth_provider.dart';
import 'providers/item_provider.dart';
import 'repositories/item_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setupLocator(); // initialize dependency injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // resolve dependencies from service locator
    final api = di.locator<ApiService>();
    final prefs = di.locator<SharedPreferences>();
    final itemRepo = di.locator<ItemRepository>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(api: api, prefs: prefs),
        ),
        ChangeNotifierProvider<ItemProvider>(
          create: (_) => ItemProvider(repository: itemRepo),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Assignment',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.indigo),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
