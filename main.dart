import 'dart:async';
import 'package:cafeee/cart_page.dart';
import 'package:cafeee/login.dart';
import 'package:cafeee/menu_page.dart';
import 'package:cafeee/orders.dart';
import 'package:cafeee/payment.dart';
import 'package:cafeee/register.dart';
import 'package:cafeee/reservation.dart';
import 'package:cafeee/settings.dart';
import 'package:cafeee/support.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIBE',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 255, 253, 151),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/': (context) => const Main(),
        '/menu': (context) => const MenuPage(),
        '/cart': (context) => const CartPage(),
        '/payment': (context) => PaymentPage(),
        '/reserve': (context) => const ReservationPage(),
        '/orders': (context) => const OrdersPage(),
        '/support': (context) => const HelpSupportPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final PageController _discountPageController = PageController();

  final List<Map<String, String>> discounts = [
    {'image': 'lib/images/banner1.jpg', 'text': '50% Off'},
    {'image': 'lib/images/banner2.jpeg', 'text': 'Happy Hours 4-6 PM'},
    {'image': 'lib/images/banner3.jpg', 'text': 'Combo Offer'},
  ];

  final List<Map<String, String>> foodItems = [
    {'image': 'lib/images/food1.jpeg', 'text': 'Pasta'},
    {'image': 'lib/images/food2.jpeg', 'text': 'Burger'},
    {'image': 'lib/images/food3.jpeg', 'text': 'Salad'},
    {'image': 'lib/images/food4.jpeg', 'text': 'Pizza'},
    {'image': 'lib/images/food5.jpeg', 'text': 'Sandwich'},
    {'image': 'lib/images/food6.jpeg', 'text': 'Noodles'},
    {'image': 'lib/images/food7.jpeg', 'text': 'Ice Cream'},
    {'image': 'lib/images/food8.jpeg', 'text': 'Fries'},
    {'image': 'lib/images/food9.jpeg', 'text': 'Soup'},
    {'image': 'lib/images/food10.jpeg', 'text': 'Cake'},
    {'image': 'lib/images/food11.jpeg', 'text': 'Chicken'},
    {'image': 'lib/images/food12.jpeg', 'text': 'Kebabs'},
  ];

  final List<String> foodOffers = [
    "🍕 Pizza Mania: Buy 1 Get 1 Free!",
    "🍔 Burger Bonanza: 20% Off on All Burgers!",
    "🍦 Ice Cream Delight: Free Sundae with Every Purchase!",
    "🍝 Pasta Lovers: 50% Off on All Pastas!",
    "🥗 Healthy Salad: 10% Off on Salads!",
    "🍰 Dessert Heaven: Free Cake Slice with Every Order!",
  ];

  List<Map<String, String>> filteredFoodItems = [];
  String loggedInUserName = 'Guest';
  late final Timer _timer;
  late AnimationController _tickerAnimationController;
  late Animation<double> _tickerAnimation;
  int _selectedIndex = 0;
  int _hoveredIndex = -1;

  @override
  void initState() {
    super.initState();
    filteredFoodItems = foodItems;
    _searchController.addListener(_filterFoodItems);

    _tickerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _tickerAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_tickerAnimationController);

    // Delay starting auto scroll until first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_discountPageController.hasClients &&
          _discountPageController.page != null) {
        int nextPage = _discountPageController.page!.round() + 1;
        if (nextPage >= discounts.length) {
          nextPage = 0;
        }
        _discountPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterFoodItems);
    _searchController.dispose();
    _discountPageController.dispose();
    _tickerAnimationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _filterFoodItems() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredFoodItems =
          foodItems
              .where(
                (foodItem) => foodItem['text']!.toLowerCase().contains(query),
              )
              .toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
      case 1:
        Navigator.pushNamed(context, '/menu');
        break;
      case 2:
        Navigator.pushNamed(context, '/reserve');
        break;
    }
  }

  void _onProfileOptionSelected(String value) {
    switch (value) {
      case 'Orders':
        Navigator.pushNamed(context, '/orders');
        break;
      case 'Help':
        Navigator.pushNamed(context, '/support');
        break;
      case 'Settings':
        Navigator.pushNamed(context, '/settings');
        break;
      case 'Logout':
        _logout();
        break;
    }
  }

  void _logout() {
    setState(() {
      loggedInUserName = 'Guest';
    });
  }

  void _updateUserName(String userName) {
    setState(() {
      loggedInUserName = userName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIBE'),
        backgroundColor: const Color.fromARGB(230, 142, 173, 69),
        leading: Padding(
          padding: const EdgeInsets.all(0),
          child: Image.asset('lib/images/vibe.jpeg', fit: BoxFit.contain),
        ),
        actions: [
          if (loggedInUserName != 'Guest')
            TextButton(
              onPressed: () {},
              child: Text(
                loggedInUserName,
                style: const TextStyle(color: Colors.white),
              ),
            )
          else
            TextButton(
              onPressed: () async {
                final userName = await Navigator.pushNamed(context, '/login');
                if (userName != null) {
                  _updateUserName(userName as String);
                }
              },
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          PopupMenuButton<String>(
            onSelected: _onProfileOptionSelected,
            itemBuilder: (BuildContext context) {
              return {'Orders', 'Help', 'Settings', 'Logout'}
                  .map(
                    (String choice) => PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    ),
                  )
                  .toList();
            },
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 30,
            color: Colors.green.withOpacity(0.2),
            child: AnimatedBuilder(
              animation: _tickerAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(-1000 * _tickerAnimation.value, 0),
                  child: Row(
                    children: List.generate(
                      foodOffers.length * 2,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Text(
                            foodOffers[index % foodOffers.length],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 350,
                      child: PageView.builder(
                        controller: _discountPageController,
                        itemCount: discounts.length,
                        itemBuilder: (context, index) {
                          return _buildDiscountItem(
                            discounts[index]['image']!,
                            discounts[index]['text']!,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search food items...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    _buildSectionTitle('Food Items'),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1,
                            childAspectRatio: 1.0,
                          ),
                      itemCount: filteredFoodItems.length,
                      itemBuilder: (context, index) {
                        return _buildFoodItem(
                          filteredFoodItems[index]['image']!,
                          filteredFoodItems[index]['text']!,
                          index,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Reserve',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _buildDiscountItem(String imagePath, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(String imagePath, String text, int index) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoveredIndex = index;
        });
      },
      onExit: (_) {
        setState(() {
          _hoveredIndex = -1;
        });
      },
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/menu');
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color:
                      _hoveredIndex == index
                          ? Colors.green.withOpacity(0.3)
                          : Colors.transparent,
                  boxShadow:
                      _hoveredIndex == index
                          ? [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ]
                          : [],
                ),
                child: Image.asset(
                  imagePath,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _hoveredIndex == index ? Colors.green : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
