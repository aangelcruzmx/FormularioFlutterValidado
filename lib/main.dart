import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:productos_app/screens/home_screen.dart';
import 'package:productos_app/screens/login_screen.dart';
import 'package:productos_app/screens/product_screen.dart';
import 'package:productos_app/screens/register_screen.dart';
import 'package:productos_app/services/products_service.dart';
void main() {
  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsService()), // Proveedor del servicio de productos
      ],
      child: ProductosApp(),
    );
  }
}

class ProductosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      initialRoute: HomeScreen.routeName, // Ruta inicial momentanea para pruebas
      routes: {
        LoginScreen.routeName: (_) => LoginScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
        RegisterScreen.routeName: (_) => RegisterScreen(),
        ProductScreen.routeName: (_) => ProductScreen(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.indigo,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 0,
        ),
      ),
    );
  }

  
}
