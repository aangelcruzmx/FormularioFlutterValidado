import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(product.picture), // Imagen del producto
            _ProductDetails(product: product), // Detalles del producto
            Positioned(
              top: 0,
              right: 0,
              child: _PriceTag(price: product.price), // Etiqueta de precio
            ),
            if (!product.available)
              Positioned(
                top: 0,
                left: 0,
                child: _NotAvailable(), // Indicación de "No disponible"
              ),
          ],
        ),
      ),
    );
  }

  // Estilo de la tarjeta
  BoxDecoration _cardBorders() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 7),
          blurRadius: 10,
        ),
      ],
    );
  }
}

// Widgets internos de la tarjeta
class _BackgroundImage extends StatelessWidget {
  final String? imageUrl;

  const _BackgroundImage(this.imageUrl);
  // Constructor con imagen opcional
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: imageUrl == null || imageUrl!.isEmpty
            ? Image.asset(
                'assets/images/no-image.png', // Imagen predeterminada si no hay URL
                fit: BoxFit.cover,
              )
            : FadeInImage(
                placeholder: AssetImage('assets/images/jar-loading.gif'), // GIF de carga
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  // Si falla la carga de la imagen desde la URL
                  return Image.asset(
                    'images/no-image.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
      ),
    );
  }
}

// Detalles del producto (nombre y disponibilidad)
class _ProductDetails extends StatelessWidget {
  final Product product;

  const _ProductDetails({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                product.name,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Disponible: ${product.available ? 'Sí' : 'No'}',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Estilo del contenedor de detalles del producto (nombre y disponibilidad)
  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
    gradient: LinearGradient(
            colors: [Colors.blue[900]!, Colors.blue[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
              borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    );
  }
}
// Etiqueta de precio del producto (en la esquina superior derecha)
class _PriceTag extends StatelessWidget {
  final double price;

  const _PriceTag({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.blue[900]!, Colors.blue[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '\$${price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
// Indicación de "No disponible" (en la esquina superior izquierda)
class _NotAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      alignment: Alignment.center,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[800]!, Colors.yellow[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      
      child: Text(
        'No disponible',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
