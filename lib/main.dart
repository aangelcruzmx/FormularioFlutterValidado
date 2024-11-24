import 'package:flutter/material.dart';
import 'package:productos_app/screens/home_screen.dart';
import 'package:productos_app/screens/login_screen.dart';
import 'package:productos_app/screens/register_screen.dart';



void main() {
  runApp(ProductosApp());
}

class ProductosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (_) => LoginScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
        RegisterScreen.routeName: (_) => RegisterScreen(),
        
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
      ),
    );
  }
}
  