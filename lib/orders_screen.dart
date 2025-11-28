
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/database_helper.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<List<Order>> _orders;

  @override
  void initState() {
    super.initState();
    _refreshOrders();
  }

  void _refreshOrders() {
    if (mounted) {
      setState(() {
        _orders = DatabaseHelper.instance.readAllOrders();
      });
    }
  }

  Future<void> _confirmOrder() async {
    final orders = await _orders;
    if (!mounted) return; // Check after await

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (orders.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('No hay pedidos para confirmar')),
      );
      return;
    }

    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final headers = {"Content-type": "application/json"};
    final body = json.encode(orders.map((order) => order.toMap()).toList());

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (!mounted) return; // Check after await

      if (response.statusCode == 201) {
        for (var order in orders) {
          await DatabaseHelper.instance.delete(order.id!);
        }
        _refreshOrders();
        messenger.showSnackBar(
          const SnackBar(content: Text('Pedido confirmado con éxito!')),
        );
        navigator.popUntil((route) => route.isFirst);
      } else {
        throw Exception('Failed to confirm order: ${response.body}');
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Error al confirmar el pedido: $e')),
      );
    }
  }

  Future<void> _showEditDialog(Order order) async {
    final observationsController = TextEditingController(text: order.observations);

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Editar Observación'),
          content: TextField(
            controller: observationsController,
            decoration: const InputDecoration(hintText: "Ingrese nuevas observaciones"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () async {
                final newOrder = Order(
                  id: order.id,
                  name: order.name,
                  price: order.price,
                  observations: observationsController.text,
                );
                await DatabaseHelper.instance.update(newOrder);
                _refreshOrders();
                if (!mounted) return;
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalle de Pedidos',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.yellow[600],
      ),
      body: FutureBuilder<List<Order>>(
        future: _orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Algo salió mal'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aún no hay pedidos'));
          }

          final orders = snapshot.data!;
          double totalPrice = orders.fold(0, (sum, item) => sum + item.price);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    order.observations,
                                    style: GoogleFonts.poppins(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${order.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _showEditDialog(order),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        await DatabaseHelper.instance.delete(order.id!);
                                        _refreshOrders();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ElevatedButton(
            onPressed: _confirmOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text('Confirmar Pedido'),
          ),
        ),
      ),
    );
  }
}
