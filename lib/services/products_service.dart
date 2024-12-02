import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'dart:io';

class ProductsService extends ChangeNotifier {
  final String _baseUrl ='flutter-varios-124f5-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Product> products = [];
  File? newPictureFile;

  late Product selectedProduct = Product(
    available: true,
    name: '',
    picture: null,
    price: 0,
  );

  bool isLoading = false;
  bool isSaving = false;

  ProductsService() {
    loadProducts();
  }

  // Cargar productos
  Future<List<Product>> loadProducts() async {
    try {
      isLoading = true;
      notifyListeners();
      products.clear();
      final url = Uri.https(_baseUrl, '/products.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> productsMap = jsonDecode(response.body);
        productsMap.forEach((key, value) {
          final tempProduct = Product.fromJson(value);
          tempProduct.id = key;
          products.add(tempProduct);
        });
        return products;
      } else {
        print('Error en la respuesta: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error de conexión: $e');
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Guardar productos
  Future<void> saveProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (newPictureFile != null) {
      final imageUrl = await uploadImage();
      if (imageUrl != null) product.picture = imageUrl;
    }

    if (product.id == null) {
      // POST
      final url = Uri.https(_baseUrl, '/products.json');
      final response = await http.post(
        url,
        body: product.toRawJson(),
      );
      final decodedData = json.decode(response.body);
      product.id = decodedData['name'];
      products.add(product);
    } else {
      // PUT
      final url = Uri.https(_baseUrl, '/products/${product.id}.json');
      await http.put(
        url,
        body: product.toRawJson(),
      );
      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) products[index] = product;
    }

    newPictureFile = null;
    isSaving = false;
    notifyListeners();
  }

  // Actualizar imagen seleccionada
  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPictureFile = File(path);
    notifyListeners();
  }

  // Subir imagen a Cloudinary
  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/rangercloud/image/upload?upload_preset=rangerpreset');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);
    imageUploadRequest.files.add(file);

    try {
      final streamResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamResponse);

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Error al subir imagen: ${response.body}');
        return null;
      }

      final decodedData = json.decode(response.body);
      return decodedData['secure_url'];
    } catch (e) {
      print('Error en la subida de imagen: $e');
      return null;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // Eliminar producto por ID de Firebase
  Future<void> deleteProduct(String id) async {
  final url = Uri.https(_baseUrl, '/products/$id.json');
  await http.delete(url);

  // Eliminar producto de la lista local
  products.removeWhere((product) => product.id == id);
  notifyListeners();
}

}
