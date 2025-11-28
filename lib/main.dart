
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/detail_screen.dart';
import 'package:myapp/orders_screen.dart';
import 'package:myapp/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/populate_database.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await populateDatabase();
  runApp(const MyApp());
}

class FoodItem {
  final String name;
  final String image;
  final double price;
  final String category;

  FoodItem({
    required this.name,
    required this.image,
    required this.price,
    required this.category,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tradición Lojana',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String _selectedCategory = 'Snacks';

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OrdersScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _onCategoryTapped(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.yellow[600],
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Tradición Lojana',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Como comer en casa',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CategoryItem(
                    title: 'Snacks',
                    icon: Icons.fastfood,
                    isSelected: _selectedCategory == 'Snacks',
                    onTap: () => _onCategoryTapped('Snacks'),
                  ),
                  CategoryItem(
                    title: 'Mariscos',
                    icon: Icons.set_meal,
                    isSelected: _selectedCategory == 'Mariscos',
                    onTap: () => _onCategoryTapped('Mariscos'),
                  ),
                  CategoryItem(
                    title: 'Pizzas',
                    icon: Icons.local_pizza,
                    isSelected: _selectedCategory == 'Pizzas',
                    onTap: () => _onCategoryTapped('Pizzas'),
                  ),
                  CategoryItem(
                    title: 'Fuertes',
                    icon: Icons.ramen_dining,
                    isSelected: _selectedCategory == 'Fuertes',
                    onTap: () => _onCategoryTapped('Fuertes'),
                  ),
                  const CategoryItem(
                    title: 'Bebidas',
                    icon: Icons.local_drink,
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('menu').where('category', isEqualTo: _selectedCategory).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SliverToBoxAdapter(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final doc = snapshot.data!.docs[index];
                    final item = FoodItem(
                      name: doc['name'],
                      image: doc['image'],
                      price: doc['price'].toDouble(),
                      category: doc['category'],
                    );
                    return MenuItem(
                      item: item,
                    );
                  },
                  childCount: snapshot.data!.docs.length,
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.title,
    required this.icon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.grey[200],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: isSelected ? Colors.orange : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final FoodItem item;

  const MenuItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image.network(
              item.image,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '25 min',
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(item: item),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Pedir'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
