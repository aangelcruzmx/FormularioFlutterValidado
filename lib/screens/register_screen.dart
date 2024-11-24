import 'package:flutter/material.dart';
import 'package:productos_app/screens/login_screen.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/auth_background.dart';
import 'package:productos_app/widgets/card_container.dart';
import 'package:productos_app/providers/register_form_provider.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = 'register';

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
                    Text('Crear Cuenta', style: Theme.of(context).textTheme.headlineMedium),
                    SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => RegisterFormProvider(),
                      child: _RegisterForm(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              //boton para ir a la pantalla de login
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, LoginScreen.routeName),
                child: Text('¿Ya tienes una cuenta? Inicia sesión',
                    style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);

    return Form(
      key: registerForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // Username
          TextFormField(
            autocorrect: false,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Angel ejemplo',
              labelText: 'Usuario',
              prefixIcon: Icons.person,
            ),
            onChanged: (value) => registerForm.username = value,
            validator: (value) {
              return value != null && value.isNotEmpty ? null : 'El usuario es obligatorio';
            },
          ),
          SizedBox(height: 20),

          // Email
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'ejemplo@gmail.com',
              labelText: 'Correo Electrónico',
              prefixIcon: Icons.email,
            ),
            onChanged: (value) => registerForm.email = value,
            validator: (value) {
              String pattern = r'^[^@]+@[^@]+\.[^@]+$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '') ? null : 'Introduce un correo válido';
            },
          ),
          SizedBox(height: 20),

          // Password
          TextFormField(
            autocorrect: false,
            obscureText: true,
            decoration: InputDecorations.authInputDecoration(
              hintText: '******',
              labelText: 'Password',
              prefixIcon: Icons.lock,
            ),
            onChanged: (value) => registerForm.password = value,
            validator: (value) {
              return value != null && value.length >= 6 ? null : 'La contraseña debe tener al menos 6 caracteres';
            },
          ),
          SizedBox(height: 20),

          // Telefono
          TextFormField(
            keyboardType: TextInputType.phone,
            decoration: InputDecorations.authInputDecoration(
              hintText: '123-456-789',
              labelText: 'Teléfono',
              prefixIcon: Icons.phone,
            ),
            onChanged: (value) => registerForm.phone = value,
            validator: (value) {
              return value != null && value.length == 10 ? null : 'Introduce un número válido de 10 dígitos';
            },
          ),
          SizedBox(height: 20),

          // Genero
          DropdownButtonFormField<String>(
            value: registerForm.gender,
            items: ['Masculino', 'Femenino'].map((gender) {
              return DropdownMenuItem(value: gender, child: Text(gender));
            }).toList(),
            onChanged: (value) => registerForm.gender = value ?? 'Masculino',
            decoration: InputDecorations.authInputDecoration(
              labelText: 'Sexo', hintText: '',
            ),
          ),
          SizedBox(height: 20),

          // Fecha de nacimiento
          TextFormField(
            readOnly: true,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Fecha de nacimiento',
              labelText: 'Fecha de Nacimiento',
              prefixIcon: Icons.calendar_today,
            ),
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                registerForm.birthDate = selectedDate;
              }
            },
            validator: (value) {
              return registerForm.birthDate != null ? null : 'Selecciona una fecha válida';
            },
          ),
          SizedBox(height: 30),

          // Botoon de registrar
          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
            color: Colors.deepPurple,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(registerForm.isLoading ? 'Espere...' : 'Registrar', style: TextStyle(color: Colors.white)),
            ),
            onPressed: registerForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    if (!registerForm.isValidForm()) return;

                    registerForm.isLoading = true;
                    await Future.delayed(Duration(seconds: 2));
                    registerForm.isLoading = false;

                    Navigator.pushReplacementNamed(context, 'home');
                  },
          ),
        ],
      ),
    );
  }
}
