import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibe_cafe/presentation/controllers/menu_controller.dart';
import 'package:vibe_cafe/presentation/controllers/cart_controller.dart';
import 'package:vibe_cafe/presentation/widgets/common/food_card.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<MenuController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Luxury Menu',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark 
                    ? [
                        const Color(0xFF1E1C1A),
                        const Color(0xFF121212),
                      ]
                    : [
                        const Color(0xFFFFFDFB),
                        const Color(0xFFFFF9F5),
                      ],
              ),
            ),
            child: Obx(
              () {
                if (controller.filteredFoodItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '☕',
                          style: TextStyle(fontSize: 56),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No items available right now', 
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: context.isTablet ? 3 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.72,
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
          ),
        );
      },
    );
  }
}
