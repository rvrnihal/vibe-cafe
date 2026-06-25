import 'package:get/get.dart';
import 'package:vibe_cafe/core/constants/enums.dart';
import 'package:vibe_cafe/data/models/food_item_model.dart';
import 'package:vibe_cafe/domain/repositories/menu_repository.dart';

class MenuController extends GetxController {
  final MenuRepository _menuRepository;

  MenuController(this._menuRepository);

  // Observables
  final RxList<FoodItem> foodItems = <FoodItem>[].obs;
  final RxList<FoodItem> filteredFoodItems = <FoodItem>[].obs;
  final RxList<FoodItem> favorites = <FoodItem>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final Rx<AppState> state = AppState.initial.obs;
  final RxString errorMessage = ''.obs;
  final RxDouble selectedPrice = 500.0.obs;
  final RxDouble selectedRating = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadFoodItems();
  }

  // Load food items
  Future<void> loadFoodItems() async {
    try {
      state.value = AppState.loading;
      final result = await _menuRepository.getFoodItems();

      result.fold(
        (failure) {
          state.value = AppState.error;
          errorMessage.value = failure.message;
        },
        (items) {
          foodItems.value = items;
          filteredFoodItems.value = items;
          favorites.value = items.where((item) => item.isFavorite).toList();
          state.value = AppState.loaded;
          errorMessage.value = '';
        },
      );
    } catch (e) {
      state.value = AppState.error;
      errorMessage.value = 'Failed to load food items';
    }
  }

  // Search food items
  Future<void> searchFoodItems(String query) async {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredFoodItems.value = foodItems;
      return;
    }

    try {
      state.value = AppState.loading;
      final result = await _menuRepository.searchFoodItems(query);

      result.fold(
        (failure) {
          state.value = AppState.error;
          errorMessage.value = failure.message;
        },
        (items) {
          filteredFoodItems.value = items;
          state.value = AppState.loaded;
          applyFilters();
        },
      );
    } catch (e) {
      state.value = AppState.error;
      errorMessage.value = 'Search failed';
    }
  }

  // Filter by category
  void filterByCategory(String category) {
    selectedCategory.value = category;
    applyFilters();
  }

  // Apply all filters
  void applyFilters() {
    var filtered = List<FoodItem>.from(foodItems);

    // Apply category filter
    if (selectedCategory.value != 'All') {
      filtered = filtered
          .where((item) => item.category.displayName == selectedCategory.value)
          .toList();
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((item) =>
              item.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              item.description
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Apply price filter
    filtered =
        filtered.where((item) => item.price <= selectedPrice.value).toList();

    // Apply rating filter
    if (selectedRating.value > 0) {
      filtered =
          filtered.where((item) => item.rating >= selectedRating.value).toList();
    }

    filteredFoodItems.value = filtered;
  }

  // Toggle favorite
  Future<void> toggleFavorite(String foodItemId) async {
    final isFavorite =
        favorites.any((item) => item.id == foodItemId);

    if (isFavorite) {
      final result = await _menuRepository.removeFromFavorites(foodItemId);
      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (_) {
          favorites.removeWhere((item) => item.id == foodItemId);
          _updateFoodItemFavoriteStatus(foodItemId, false);
        },
      );
    } else {
      final result = await _menuRepository.addToFavorites(foodItemId);
      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (_) {
          final item = foodItems.firstWhere((item) => item.id == foodItemId);
          favorites.add(item);
          _updateFoodItemFavoriteStatus(foodItemId, true);
        },
      );
    }
  }

  // Update favorite status in lists
  void _updateFoodItemFavoriteStatus(String foodItemId, bool isFavorite) {
    for (int i = 0; i < foodItems.length; i++) {
      if (foodItems[i].id == foodItemId) {
        foodItems[i] = foodItems[i].copyWith(isFavorite: isFavorite);
        break;
      }
    }

    for (int i = 0; i < filteredFoodItems.length; i++) {
      if (filteredFoodItems[i].id == foodItemId) {
        filteredFoodItems[i] =
            filteredFoodItems[i].copyWith(isFavorite: isFavorite);
        break;
      }
    }
  }

  // Get food item by ID
  FoodItem? getFoodItemById(String id) {
    try {
      return foodItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get recommended items (popular + high rating)
  List<FoodItem> getRecommendedItems() {
    return foodItems
        .where((item) => item.isPopular || item.rating >= 4.5)
        .take(5)
        .toList();
  }

  // Get trending items
  List<FoodItem> getTrendingItems() {
    return foodItems
        .where((item) => item.reviewCount > 100)
        .take(5)
        .toList();
  }

  // Reset filters
  void resetFilters() {
    searchQuery.value = '';
    selectedCategory.value = 'All';
    selectedPrice.value = 500.0;
    selectedRating.value = 0.0;
    filteredFoodItems.value = foodItems;
  }
}
