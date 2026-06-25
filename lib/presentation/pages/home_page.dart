import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import 'package:vibe_cafe/config/app_routes.dart';
import 'package:vibe_cafe/core/utils/extensions.dart';
import 'package:vibe_cafe/presentation/controllers/menu_controller.dart';
import 'package:vibe_cafe/presentation/controllers/cart_controller.dart';
import 'package:vibe_cafe/presentation/controllers/auth_controller.dart';
import 'package:vibe_cafe/presentation/widgets/common/food_card.dart';
import 'package:vibe_cafe/presentation/widgets/common/search_bar_widget.dart';
import 'package:vibe_cafe/presentation/widgets/common/category_chips.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedBottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuController>(
      builder: (controller) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: _buildBody(context, controller),
          bottomNavigationBar: _buildBottomNavigation(context),
          floatingActionButton: _buildFloatingActionButton(context),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.colorScheme.surface,
      title: Text(
        'Vibe Cafe',
        style: context.textTheme.headlineMedium?.copyWith(
          color: context.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_none_outlined,
              color: context.colorScheme.primary),
          onPressed: () {},
        ),
        Obx(() {
          final authController = Get.find<AuthController>();
          if (authController.isLoggedIn) {
            return Row(
              children: [
                Text(
                  'Hi, ${authController.currentUser.value!.name.split(' ').first}',
                  style: context.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.primary,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.person_outline,
                      color: context.colorScheme.primary),
                  onPressed: () => Get.toNamed(AppRoutes.profile),
                ),
              ],
            );
          } else {
            return TextButton(
              onPressed: () => Get.toNamed(AppRoutes.login),
              child: const Text('Login'),
            );
          }
        }),
      ],
    );
  }

  Widget _buildBody(BuildContext context, MenuController controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            SearchBarWidget(
              onSearch: (query) {
                controller.searchFoodItems(query);
              },
            ),
            const SizedBox(height: 20),

            // Offers Section
            _buildOffersSection(context),
            const SizedBox(height: 24),

            // Categories Section
            Text(
              'Categories',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            CategoryChips(
              selectedCategory: controller.selectedCategory,
              onCategorySelected: (category) {
                controller.filterByCategory(category);
              },
            ),
            const SizedBox(height: 24),

            // Trending Section
            Text(
              '🔥 Trending Now',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () {
                final trendingItems = controller.getTrendingItems();
                if (trendingItems.isEmpty) {
                  return _buildEmptyState(context);
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: context.isTablet ? 3 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: trendingItems.length,
                  itemBuilder: (context, index) => FoodCard(
                    foodItem: trendingItems[index],
                    onFavoriteToggle: () =>
                        controller.toggleFavorite(trendingItems[index].id),
                    onAddToCart: () {
                      Get.find<CartController>().addItemToCart(
                        foodItemId: trendingItems[index].id,
                        foodName: trendingItems[index].name,
                        foodImage: trendingItems[index].imageUrl,
                        foodPrice: trendingItems[index].price,
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Recommended Section
            Text(
              '⭐ Recommended For You',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () {
                final recommendedItems = controller.getRecommendedItems();
                if (recommendedItems.isEmpty) {
                  return _buildEmptyState(context);
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: context.isTablet ? 3 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: recommendedItems.length,
                  itemBuilder: (context, index) => FoodCard(
                    foodItem: recommendedItems[index],
                    onFavoriteToggle: () =>
                        controller.toggleFavorite(recommendedItems[index].id),
                    onAddToCart: () {
                      Get.find<CartController>().addItemToCart(
                        foodItemId: recommendedItems[index].id,
                        foodName: recommendedItems[index].name,
                        foodImage: recommendedItems[index].imageUrl,
                        foodPrice: recommendedItems[index].price,
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOffersSection(BuildContext context) {
    final offers = [
      {'emoji': '🎉', 'title': '50% OFF', 'subtitle': 'On First Order'},
      {'emoji': '🍕', 'title': 'Free Delivery', 'subtitle': 'Above ₹299'},
      {'emoji': '⭐', 'title': 'Loyalty Points', 'subtitle': 'Every Purchase'},
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: offers.length,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.only(right: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.colorScheme.primary.withOpacity(0.8),
                  context.colorScheme.primary.withOpacity(0.4),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    offers[index]['emoji']!,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    offers[index]['title']!,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    offers[index]['subtitle']!,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Text(
              '🔍',
              style: context.textTheme.displayLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: context.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigation(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedBottomIndex,
      onTap: (index) {
        setState(() => _selectedBottomIndex = index);
        _navigateFromBottomNav(index);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu), label: 'Menu'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
      ],
    );
  }

  void _navigateFromBottomNav(int index) {
    switch (index) {
      case 0:
        Get.toNamed(AppRoutes.home);
        break;
      case 1:
        Get.toNamed(AppRoutes.menu);
        break;
      case 2:
        Get.toNamed(AppRoutes.cart);
        break;
      case 3:
        Get.toNamed(AppRoutes.orders);
        break;
      case 4:
        Get.toNamed(AppRoutes.settings);
        break;
    }
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Get.toNamed(AppRoutes.reservation),
      child: const Icon(Icons.calendar_today),
    );
  }
}
