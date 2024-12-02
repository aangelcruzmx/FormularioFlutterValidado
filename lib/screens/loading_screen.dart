import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  static const String routeName = 'loading';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cargando Productos'),
      ),
      body: Center(
        child: CircularProgressIndicator(color: Colors.indigo),
      ),
    );
  }
}
