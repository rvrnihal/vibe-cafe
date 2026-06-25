import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import 'package:vibe_cafe/presentation/controllers/menu_controller.dart';
import 'package:vibe_cafe/presentation/controllers/cart_controller.dart';
import 'package:vibe_cafe/presentation/widgets/common/food_card.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Menu'),
            centerTitle: true,
          ),
          body: Obx(
            () {
              if (controller.filteredFoodItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant_menu_outlined,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text('No items available', style: context.textTheme.bodyLarge),
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: context.isTablet ? 3 : 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: controller.filteredFoodItems.length,
                itemBuilder: (context, index) {
                  final item = controller.filteredFoodItems[index];
                  return FoodCard(
                    foodItem: item,
                    onFavoriteToggle: () => controller.toggleFavorite(item.id),
                    onAddToCart: () {
                      Get.find<CartController>().addItemToCart(
                        foodItemId: item.id,
                        foodName: item.name,
                        foodImage: item.imageUrl,
                        foodPrice: item.price,
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
