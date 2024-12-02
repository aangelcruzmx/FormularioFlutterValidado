import 'package:flutter/material.dart';
import 'package:productos_app/screens/register_screen.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/auth_background.dart';
import 'package:productos_app/widgets/card_container.dart';

import 'package:provider/provider.dart';
import 'package:productos_app/providers/login_form_provider.dart';

class LoginScreen extends StatelessWidget {

static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  RegisterScreen.routeName,
                ),
                child: Text(
                  'Crear una nueva cuenta',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//--------------------------------------------
// Formulario de Login
class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            SizedBox(height: 10),
            // Campo de email con validación
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'ejemplo@gmail.com',
                labelText: 'Email',
                prefixIcon: Icons.alternate_email,
              ),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern = r'^[^@]+@[^@]+\.[^@]+$';//expresión regular para validar email
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '') ? null : 'Introduce un email válido';
              },
            ),
            SizedBox(height: 20),

            // Campo de contraseña con validación
            TextFormField(
              autocorrect: false,
              obscureText: true,
              decoration: InputDecorations.authInputDecoration(
                hintText: '******',
                labelText: 'Password',
                prefixIcon: Icons.lock_outline,
              ),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe tener al menos 6 caracteres';
              },
            ),
            SizedBox(height: 30),

            // Botón de acceder
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      if (!loginForm.isValidForm()) return;

                      loginForm.isLoading = true;
                      await Future.delayed(Duration(seconds: 2));
                      loginForm.isLoading = false;

                      Navigator.pushReplacementNamed(context, 'home');
                    },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading ? 'Espere...' : 'Acceder',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

           //contraeña olvidada
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                //se podria redirigir a una nueva pantalla o mostrar un diálogo
                print("Olvidaste tu contraseña presionado");
              },
              child: Text(
                '¿Olvidaste la contraseña?',
                style: TextStyle(fontSize: 16, color: Colors.deepPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
