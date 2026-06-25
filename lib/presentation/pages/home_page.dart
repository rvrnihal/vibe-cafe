import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibe_cafe/config/app_routes.dart';
import 'package:vibe_cafe/core/utils/extensions.dart';
import 'package:vibe_cafe/presentation/controllers/menu_controller.dart';
import 'package:vibe_cafe/presentation/controllers/cart_controller.dart';
import 'package:vibe_cafe/presentation/controllers/auth_controller.dart';
import 'package:vibe_cafe/data/models/user_model.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<MenuController>(
      builder: (controller) {
        return Scaffold(
          appBar: _buildAppBar(context),
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
            child: _buildBody(context, controller),
          ),
          bottomNavigationBar: _buildBottomNavigation(context),
          floatingActionButton: _buildFloatingActionButton(context),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        'Vibe Cafe',
        style: GoogleFonts.poppins(
          color: context.colorScheme.primary,
          fontWeight: FontWeight.w800,
          fontSize: 24,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications_none_outlined,
            color: context.colorScheme.primary,
            size: 26,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        Obx(() {
          final authController = Get.find<AuthController>();
          if (authController.isLoggedIn) {
            final user = authController.currentUser.value!;
            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: () => Get.toNamed(AppRoutes.profile),
                borderRadius: BorderRadius.circular(20),
                child: Row(
                  children: [
                    Text(
                      'Hi, ${user.name.split(' ').first}',
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.primaryContainer,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.colorScheme.primary.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.transparent,
                        child: Text('👤', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextButton(
                onPressed: () => Get.toNamed(AppRoutes.login),
                child: Text(
                  'Login',
                  style: context.textTheme.titleSmall?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          }
        }),
      ],
    );
  }

  Widget _buildBody(BuildContext context, MenuController controller) {
    final authController = Get.find<AuthController>();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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

            // Loyalty Rewards Card
            Obx(() {
              if (authController.isLoggedIn && authController.currentUser.value != null) {
                return Column(
                  children: [
                    _buildLoyaltyCard(context, authController.currentUser.value!),
                    const SizedBox(height: 24),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),

            // Offers Section
            Text(
              'Exclusive Offers',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: context.colorScheme.primaryContainer,
              ),
            ),
            const SizedBox(height: 12),
            _buildOffersSection(context),
            const SizedBox(height: 24),

            // Categories Section
            Text(
              'Categories',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: context.colorScheme.primaryContainer,
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
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: context.colorScheme.primaryContainer,
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
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.72,
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
            const SizedBox(height: 28),

            // Recommended Section
            Text(
              '⭐ Recommended For You',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: context.colorScheme.primaryContainer,
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
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.72,
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
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLoyaltyCard(BuildContext context, User user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4B2E2B), // Espresso Dark
            Color(0xFF6F4E37), // Coffee Brown
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4B2E2B).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VIP CAFE MEMBER',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFF6C453), // Accent gold
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user.name,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white12,
                child: Text(
                  '👑',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Loyalty Points',
                    style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${user.loyaltyPoints} pts',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFF6C453),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wallet Balance',
                    style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (user.walletBalance ?? 0.0).toCurrency(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOffersSection(BuildContext context) {
    final offers = [
      {
        'emoji': '🎉', 
        'title': '50% OFF', 
        'subtitle': 'On First Order',
        'color1': const Color(0xFF6F4E37),
        'color2': const Color(0xFFC68E5A),
      },
      {
        'emoji': '☕', 
        'title': 'Free Brew', 
        'subtitle': 'Above ₹299',
        'color1': const Color(0xFF4B2E2B),
        'color2': const Color(0xFF6F4E37),
      },
      {
        'emoji': '⭐', 
        'title': 'Double Pts', 
        'subtitle': 'Happy Hours',
        'color1': const Color(0xFFC68E5A),
        'color2': const Color(0xFFF6C453),
      },
    ];

    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return Container(
            width: 170,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  offer['color1'] as Color,
                  offer['color2'] as Color,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: (offer['color1'] as Color).withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    offer['emoji'] as String,
                    style: const TextStyle(fontSize: 26),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    offer['title'] as String,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    offer['subtitle'] as String,
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Text(
              '☕',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 16),
            Text(
              'No products found matching filters.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
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
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined), 
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu_outlined), 
          activeIcon: Icon(Icons.restaurant_menu),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined), 
          activeIcon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_outlined), 
          activeIcon: Icon(Icons.receipt),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz_outlined), 
          activeIcon: Icon(Icons.more_horiz),
          label: 'More',
        ),
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
      backgroundColor: context.colorScheme.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: const Icon(Icons.calendar_month),
    );
  }
}
