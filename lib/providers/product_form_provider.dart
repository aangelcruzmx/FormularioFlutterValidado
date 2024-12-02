import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Conexión al formulario

  Product product; // Producto conectado al formulario

  // Constructor
  ProductFormProvider(this.product);

  // Validar formulario
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  // para actualizar la disponibilidad del producto
  void updateAvailability(bool value) {
    product.available = value;
    notifyListeners(); // Notificar cambios a los listeners
  }
}
