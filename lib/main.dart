import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/packages_viewmodel.dart';
import 'viewmodels/user_viewmodel.dart';
import 'views/login_view.dart';

// Punto de entrada de la app: Flutter empieza a ejecutar aquí.
void main() => runApp(const DropXApp());

// Widget raíz: configura la app completa (nombre, tema y pantalla inicial).
class DropXApp extends StatelessWidget {
  const DropXApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider crea los ViewModels y los deja disponibles para todas
    // las pantallas (context.read / context.watch). Va por encima del
    // MaterialApp para que lo vean tanto el login como el Home.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => PackagesViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: MaterialApp(
        title: 'DropX',
        debugShowCheckedModeBanner: false, // quita la cinta "debug"
        theme: AppTheme.light, // colores y estilos globales (core/app_theme.dart)
        home: const LoginView(), // Pantalla inicial
      ),
    );
  }
}
