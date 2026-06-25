import 'package:dartz/dartz.dart';
import 'package:vibe_cafe/core/errors/failures.dart';
import 'package:vibe_cafe/data/models/food_item_model.dart';

abstract class MenuRepository {
  Future<Either<Failure, List<FoodItem>>> getFoodItems();
  Future<Either<Failure, List<FoodItem>>> searchFoodItems(String query);
  Future<Either<Failure, FoodItem>> getFoodItemById(String id);
  Future<Either<Failure, void>> addToFavorites(String foodId);
  Future<Either<Failure, void>> removeFromFavorites(String foodId);
  Future<Either<Failure, List<String>>> getFavorites();
}
