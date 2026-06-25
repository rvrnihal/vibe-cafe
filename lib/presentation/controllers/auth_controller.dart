import 'package:get/get.dart';
import 'package:vibe_cafe/data/datasources/local_data_source.dart';
import 'package:vibe_cafe/data/models/user_model.dart';

class AuthController extends GetxController {
  final LocalDataSource _localDataSource;

  AuthController(this._localDataSource);

  final Rxn<User> currentUser = Rxn<User>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final user = await _localDataSource.getCachedUser();
      if (user != null) {
        currentUser.value = user;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load user session';
    }
  }

  bool get isLoggedIn => currentUser.value != null;

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Simple mock login logic
      if (email.toLowerCase().trim() == 'admin@vibe.com' && password == 'password123') {
        final mockUser = User(
          id: '1',
          name: 'Vibe Administrator',
          email: email,
          phone: '+91 99999 88888',
          address: 'Vibe Cafe Headquarters, Ring Road',
          city: 'Bangalore',
          state: 'Karnataka',
          pincode: '560001',
          walletBalance: 2500.0,
          loyaltyPoints: 120,
          createdAt: DateTime.now(),
        );

        await _localDataSource.cacheUser(mockUser);
        await _localDataSource.cacheToken('mock-jwt-token-12345');
        currentUser.value = mockUser;
        Get.snackbar('Welcome', 'Login successful!', snackPosition: SnackPosition.BOTTOM);
        return true;
      } else {
        errorMessage.value = 'Invalid email or password. Use admin@vibe.com / password123';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred during login';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phone: phone,
        walletBalance: 100.0, // Welcome bonus wallet balance
        loyaltyPoints: 10,
        createdAt: DateTime.now(),
      );

      await _localDataSource.cacheUser(newUser);
      await _localDataSource.cacheToken('mock-jwt-token-new');
      currentUser.value = newUser;
      Get.snackbar('Welcome', 'Registration successful!', snackPosition: SnackPosition.BOTTOM);
      return true;
    } catch (e) {
      errorMessage.value = 'An error occurred during registration';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _localDataSource.clearCache();
      currentUser.value = null;
      Get.snackbar('Logged Out', 'Logged out successfully.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to log out.', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
