import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibe_cafe/core/errors/exceptions.dart';
import 'package:vibe_cafe/data/models/user_model.dart';
import 'dart:convert';

abstract class LocalDataSource {
  Future<void> cacheUser(User user);
  Future<User?> getCachedUser();
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearCache();
  Future<void> saveFavorites(List<String> favoriteIds);
  Future<List<String>> getFavorites();
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({required this.sharedPreferences});

  static const _userKey = 'cached_user';
  static const _tokenKey = 'auth_token';
  static const _favoritesKey = 'favorites';

  @override
  Future<void> cacheUser(User user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await sharedPreferences.setString(_userKey, userJson);
    } catch (e) {
      throw CacheException(
        message: 'Failed to cache user',
        originalException: e,
      );
    }
  }

  @override
  Future<User?> getCachedUser() async {
    try {
      final userJson = sharedPreferences.getString(_userKey);
      if (userJson == null) return null;

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    } catch (e) {
      throw CacheException(
        message: 'Failed to retrieve cached user',
        originalException: e,
      );
    }
  }

  @override
  Future<void> cacheToken(String token) async {
    try {
      await sharedPreferences.setString(_tokenKey, token);
    } catch (e) {
      throw CacheException(
        message: 'Failed to cache token',
        originalException: e,
      );
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return sharedPreferences.getString(_tokenKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to retrieve token',
        originalException: e,
      );
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(_userKey);
      await sharedPreferences.remove(_tokenKey);
      await sharedPreferences.remove(_favoritesKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear cache',
        originalException: e,
      );
    }
  }

  @override
  Future<void> saveFavorites(List<String> favoriteIds) async {
    try {
      await sharedPreferences.setStringList(_favoritesKey, favoriteIds);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save favorites',
        originalException: e,
      );
    }
  }

  @override
  Future<List<String>> getFavorites() async {
    try {
      return sharedPreferences.getStringList(_favoritesKey) ?? [];
    } catch (e) {
      throw CacheException(
        message: 'Failed to get favorites',
        originalException: e,
      );
    }
  }
}
