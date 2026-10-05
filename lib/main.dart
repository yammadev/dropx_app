import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'viewmodels/login_viewmodel.dart';
import 'views/login_view.dart';

// Punto de entrada de la app: Flutter empieza a ejecutar aquí.
void main() => runApp(const DropXApp());

// Widget raíz: configura la app completa (nombre, tema y pantalla inicial).
class DropXApp extends StatelessWidget {
  const DropXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DropX',
      debugShowCheckedModeBanner: false, // quita la cinta "debug"
      theme: AppTheme.light, // colores y estilos globales (core/app_theme.dart)

      // Pantalla inicial. Por ahora es el login; las rutas llegan con el Home.
      // ChangeNotifierProvider crea el LoginViewModel y lo deja disponible
      // para LoginView (y sus hijos) mediante context.read / context.watch.
      home: ChangeNotifierProvider(
        create: (_) => LoginViewModel(),
        child: const LoginView(),
      ),
    );
  }
}
