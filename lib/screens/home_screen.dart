import 'package:flutter/material.dart';

import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: ListView.builder(
        itemCount: 10, // Mostramos 10 elementos por ahora
        itemBuilder: (BuildContext context, int index) {
          return ProductCard(); // Sustituimos el Text por ProductCard
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Acción del botón flotante
        },
      ),
    );
  }
}
