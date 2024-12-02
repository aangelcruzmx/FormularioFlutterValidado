import 'package:flutter/material.dart';
import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/widgets/enhanced_save_button.dart';
import 'package:provider/provider.dart';
import '../ui/input_decorations.dart';
import '../widgets/product_image.dart';
import 'package:image_picker/image_picker.dart';
import '../services/products_service.dart';

class ProductScreen extends StatelessWidget {
  static const String routeName = 'product';

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productService.selectedProduct),// Crear un nuevo Provider
      child: _ProductScreenBody(productService: productService),// Pasar el servicio como argumento
    );
  }
}
 // Cuerpo de la pantalla de producto 
class _ProductScreenBody extends StatelessWidget {
  final ProductsService productService;

  const _ProductScreenBody({required this.productService});
  
  @override
  Widget build(BuildContext context) {// Obtener el formulario del producto
    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(url: productForm.product.picture),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new, size: 40, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt_outlined, size: 40, color: Colors.white),
                    onPressed: productService.isSaving
                        ? null
                        : () async {
                            await _processImage(context, ImageSource.camera);
                          },
                  ),
                ),
                Positioned(
                  top: 120,
                  right: 20,
                  child: IconButton(
                    icon: Icon(Icons.photo_library_outlined, size: 40, color: Colors.white),
                    onPressed: productService.isSaving
                        ? null
                        : () async {
                            await _processImage(context, ImageSource.gallery);
                          },
                  ),
                ),
              ],
            ),
            _ProductForm(),
            SizedBox(height: 20), // Espaciado entre el formulario y el botón
            EnhancedSaveButton(
              isSaving: productService.isSaving,
              onPressed: () async {
                if (!productForm.isValidForm()) return;
                await productService.saveProduct(productForm.product);
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 20), // Espaciado adicional para mejor visualización
          ],
        ),
      ),
    );
  }

  Future<void> _processImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 100,
    );
    if (pickedFile == null) {
      print('No se seleccionó ninguna imagen');
      return;
    }
    print('Imagen seleccionada: ${pickedFile.path}');
    Provider.of<ProductsService>(context, listen: false)
        .updateSelectedProductImage(pickedFile.path);
  }
}


// Formulario de producto
class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productForm.formKey,
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                initialValue: productForm.product.name,
                onChanged: (value) => productForm.product.name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre:',
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: '${productForm.product.price}',
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (double.tryParse(value) == null) {
                    productForm.product.price = 0;
                  } else {
                    productForm.product.price = double.parse(value);
                  }
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: '150€',
                  labelText: 'Precio:',
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      productForm.product.fecha ?? 'Seleccionar fecha',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today_outlined),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        productForm.product.fecha =
                            "${pickedDate.toLocal()}".split(' ')[0];
                        productForm.notifyListeners();
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              SwitchListTile.adaptive(
                value: productForm.product.available,
                title: Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: productForm.updateAvailability,
              ),
            ],
          ),
        ),
      ),
    );
  }

    // Decoración del contenedor
    BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          offset: Offset(0, 5),
          blurRadius: 5,
        ),
      ],
    );
  }
}
