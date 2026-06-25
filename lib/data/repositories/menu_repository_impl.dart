import 'package:dartz/dartz.dart';
import 'package:vibe_cafe/core/errors/exceptions.dart';
import 'package:vibe_cafe/core/errors/failures.dart';
import 'package:vibe_cafe/data/datasources/local_data_source.dart';
import 'package:vibe_cafe/data/datasources/remote_data_source.dart';
import 'package:vibe_cafe/data/models/food_item_model.dart';
import 'package:vibe_cafe/domain/repositories/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  MenuRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<FoodItem>>> getFoodItems() async {
    try {
      final items = await remoteDataSource.getFoodItems();
      
      // Get favorites from local storage
      final favorites = await localDataSource.getFavorites();
      
      // Mark favorite items
      final itemsWithFavorites = items
          .map((item) => item.copyWith(isFavorite: favorites.contains(item.id)))
          .toList();
      
      return Right(itemsWithFavorites);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Exception catch (e) {
      return Left(GenericFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FoodItem>>> searchFoodItems(String query) async {
    try {
      if (query.isEmpty) {
        return const Right([]);
      }

      final items = await remoteDataSource.searchFoodItems(query);
      
      // Get favorites from local storage
      final favorites = await localDataSource.getFavorites();
      
      // Mark favorite items
      final itemsWithFavorites = items
          .map((item) => item.copyWith(isFavorite: favorites.contains(item.id)))
          .toList();
      
      return Right(itemsWithFavorites);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Exception catch (e) {
      return Left(GenericFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FoodItem>> getFoodItemById(String id) async {
    try {
      final item = await remoteDataSource.getFoodItemById(id);
      
      // Check if it's in favorites
      final favorites = await localDataSource.getFavorites();
      final itemWithFavorite = item.copyWith(
        isFavorite: favorites.contains(item.id),
      );
      
      return Right(itemWithFavorite);
    } on ClientException catch (e) {
      return Left(ClientFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Exception catch (e) {
      return Left(GenericFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(String foodId) async {
    try {
      final favorites = await localDataSource.getFavorites();
      
      if (!favorites.contains(foodId)) {
        favorites.add(foodId);
        await localDataSource.saveFavorites(favorites);
      }
      
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on Exception catch (e) {
      return Left(GenericFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String foodId) async {
    try {
      final favorites = await localDataSource.getFavorites();
      favorites.removeWhere((id) => id == foodId);
      await localDataSource.saveFavorites(favorites);
      
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on Exception catch (e) {
      return Left(GenericFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavorites();
      return Right(favorites);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on Exception catch (e) {
      return Left(GenericFailure(message: e.toString()));
    }
  }
}
