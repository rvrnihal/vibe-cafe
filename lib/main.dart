import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import 'package:vibe_cafe/domain/repositories/menu_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibe_cafe/core/theme/app_theme.dart';
import 'package:vibe_cafe/data/datasources/local_data_source.dart';
import 'package:vibe_cafe/data/datasources/remote_data_source.dart';
import 'package:vibe_cafe/data/repositories/menu_repository_impl.dart';
import 'package:vibe_cafe/presentation/controllers/cart_controller.dart';
import 'package:vibe_cafe/presentation/controllers/menu_controller.dart';
import 'package:vibe_cafe/presentation/controllers/auth_controller.dart';
import 'package:vibe_cafe/config/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await _initializeDependencies();
  
  runApp(const MyApp());
}

Future<void> _initializeDependencies() async {
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // Register data sources
  Get.put<LocalDataSource>(
    LocalDataSourceImpl(sharedPreferences: sharedPreferences),
  );
  Get.put<RemoteDataSource>(RemoteDataSourceImpl());
  
  // Register repositories
  Get.put<MenuRepository>(
    MenuRepositoryImpl(
      remoteDataSource: Get.find(),
      localDataSource: Get.find(),
    ),
  );
  
  // Register controllers
  Get.put(MenuController(Get.find<MenuRepository>()));
  Get.put(CartController());
  Get.put(AuthController(Get.find<LocalDataSource>()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vibe Cafe',
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      
      // Routes configuration
      getPages: AppRoutes.getPages,
      initialRoute: AppRoutes.splash,
      
      // Global transitions
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
      
      // Other configurations
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
    );
  }
}
