import 'dart:convert';

class Product {
  bool available;
  String name;
  String? picture; // Campo opcional
  double price; // Cambiado de `int` a `double` para precisión
  String? id; // Campo adicional para el ID de Firebase
  String? fecha; // Nuevo campo para la fecha

  Product({
    required this.available,
    required this.name,
    this.picture,
    required this.price,
    this.id, //id puede ser null por que no siempre se pasa
    this.fecha, //fecha puede ser null por que no siempre se pasa
  });

  Product copy() => Product(
  available: this.available,
  name: this.name,
  picture: this.picture,
  price: this.price,
  id: this.id,
  fecha: this.fecha,
);

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  // mapero de los datos a un objeto 
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        available: json["available"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"]?.toDouble(),
        id: json["id"],
        fecha: json["fecha"], 
      );
  // mapeo de los datos a json para enviarlos a la base de datos
  Map<String, dynamic> toJson() => {
        "available": available,
        "name": name,
        "picture": picture,
        "price": price,
        "id": id,
        "fecha": fecha, 
      };
}
