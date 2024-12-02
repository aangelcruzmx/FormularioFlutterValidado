import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? url; // Aceptamos una URL opcional

  const ProductImage({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        width: double.infinity,
        height: 450,
        decoration: _buildBoxDecoration(),
        child: Opacity(
          opacity: 0.9, // Aplicamos opacidad para mejorar visibilidad
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(45),
              bottomRight: Radius.circular(45),
            ),
            child:getImage(url), // Mostramos la imagen
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.black, // Color de fondo para contraste
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(45),
        bottomRight: Radius.circular(45),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    );
  }

  Widget getImage(String? picture){
    if(picture == null){
      return const Image(image: AssetImage('assets/images/no-image.png'),
      fit: BoxFit.cover,);
  }
  if(picture.startsWith('http')){
    return FadeInImage(
      placeholder: const AssetImage('assets/images/jar-loading.gif'),
      image: NetworkImage(picture),
      fit: BoxFit.cover,
    );
  } else {
    return Image.file(
      File(picture),
      fit: BoxFit.cover,
    );
  }
  }





}
