
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/main.dart';

Future<void> populateDatabase() async {
  try {
    final CollectionReference menuCollection =
        FirebaseFirestore.instance.collection('menu');

    final List<FoodItem> foodItems = [
      // Snacks
      FoodItem(
        name: 'Salchipapas',
        image: 'https://i.imgur.com/8wSFC3A.jpeg',
        price: 3.50,
        category: 'Snacks',
      ),
      FoodItem(
        name: 'Empanada de Viento',
        image: 'https://i.imgur.com/kdkT20P.jpeg',
        price: 1.50,
        category: 'Snacks',
      ),
      FoodItem(
        name: 'Humita',
        image: 'https://i.imgur.com/z4TnA9p.jpeg',
        price: 2.00,
        category: 'Snacks',
      ),
      // Mariscos
      FoodItem(
        name: 'Ceviche',
        image: 'https://i.imgur.com/tTz9tL2.jpeg',
        price: 8.00,
        category: 'Mariscos',
      ),
      FoodItem(
        name: 'Encebollado',
        image: 'https://i.imgur.com/5wT7g6R.jpeg',
        price: 7.50,
        category: 'Mariscos',
      ),
      // Pizzas
      FoodItem(
        name: 'Pizza de Pepperoni',
        image: 'https://i.imgur.com/uR1a3pT.jpeg',
        price: 12.00,
        category: 'Pizzas',
      ),
      FoodItem(
        name: 'Pizza Hawaiana',
        image: 'https://i.imgur.com/I7a5UvL.jpeg',
        price: 13.00,
        category: 'Pizzas',
      ),
      // Fuertes
      FoodItem(
        name: 'Fritada',
        image: 'https://i.imgur.com/5Lz1k3w.jpeg',
        price: 9.00,
        category: 'Fuertes',
      ),
      FoodItem(
        name: 'Hornado',
        image: 'https://i.imgur.com/A6l1H4n.jpeg',
        price: 10.00,
        category: 'Fuertes',
      ),
      // Bebidas
      FoodItem(
        name: 'Jugo de Tomate',
        image: 'https://i.imgur.com/fL3sYJ3.jpeg',
        price: 2.50,
        category: 'Bebidas',
      ),
      FoodItem(
        name: 'Agua de Horchata',
        image: 'https://i.imgur.com/sC5xZ7e.jpeg',
        price: 2.00,
        category: 'Bebidas',
      ),
    ];

    final snapshot = await menuCollection.get();

    if (snapshot.docs.length != foodItems.length) {
      final WriteBatch batch = FirebaseFirestore.instance.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      final WriteBatch newBatch = FirebaseFirestore.instance.batch();
      for (var item in foodItems) {
        final docRef = menuCollection.doc();
        newBatch.set(docRef, {
          'name': item.name,
          'image': item.image,
          'price': item.price,
          'category': item.category,
        });
      }
      await newBatch.commit();
    }
  } catch (e, s) {
    developer.log(
      'Error populating database',
      name: 'myapp.database',
      error: e,
      stackTrace: s,
    );
  }
}
