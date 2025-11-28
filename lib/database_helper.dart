
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Order {
  final int? id;
  final String name;
  final double price;
  final String observations;

  Order({this.id, required this.name, required this.price, required this.observations});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'observations': observations,
    };
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('orders.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE orders (
  id $idType,
  name $textType,
  price $doubleType,
  observations $textType
)
''');
  }

  Future<Order> create(Order order) async {
    final db = await instance.database;
    await db.insert('orders', order.toMap());
    return order;
  }

  Future<List<Order>> readAllOrders() async {
    final db = await instance.database;
    final result = await db.query('orders');

    return result.map((json) => Order(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as double,
      observations: json['observations'] as String,
    )).toList();
  }

  Future<int> update(Order order) async {
    final db = await instance.database;

    return db.update(
      'orders',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
