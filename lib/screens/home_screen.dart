import 'package:flutter/material.dart';
import 'package:productos_app/models/product.dart';
import 'package:provider/provider.dart';
import '../services/products_service.dart';
import '../widgets/product_card.dart';
import '../widgets/enhanced_floating_action_button.dart';
import '../screens/loading_screen.dart'; // LoadingScreen para mostrar pantalla de carga

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home';

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    // Mostrar pantalla de carga si está cargando productos
    if (productsService.isLoading) {
      return LoadingScreen(); // Mantener LoadingScreen
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Productos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Botón de cerrar sesión
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.login_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'login'); // Navegar a LoginScreen
            },
          ),
        ],
        elevation: 4,
      ),

      // Cuerpo de la pantalla con Pull-to-Refresh para recargar productos cuando se desliza hacia abajo
      body: RefreshIndicator(
        onRefresh: () async {
          // Llama al método loadProducts en el servicio
          await productsService.loadProducts();
        },
        child: productsService.products.isEmpty
            ? Center(
                child: Text('No hay productos disponibles'),
              )
            : ListView.builder(
                itemCount: productsService.products.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = productsService.products[index];
                  return Dismissible(
                    key: Key(product.id ?? ''),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete_forever, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Confirmar'),
                          content: Text('¿Estás seguro de que quieres eliminar este producto?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Eliminar'),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) {
                      productsService.deleteProduct(product.id!);
                    },
                    child: GestureDetector(
                      onTap: () {
                        productsService.selectedProduct = product.copy();
                        Navigator.pushNamed(context, 'product');
                      },
                      child: ProductCard(product: product),
                    ),
                  );
                },
              ),
      ),

      // Botón flotante para agregar un nuevo producto
      floatingActionButton: EnhancedFloatingActionButton(
        onPressed: () {
          // Al presionar el botón, navegar directamente a ProductScreen
          productsService.selectedProduct = Product(
            available: true,
            name: '',
            picture: null,
            price: 0,
          );
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}
