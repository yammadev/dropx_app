import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../viewmodels/login_viewmodel.dart';
import 'home_view.dart';

// Pantalla de login. Es StatefulWidget porque necesita guardar los
// controladores de los campos de texto (que hay que liberar al cerrar).
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // ---------- Controladores ----------
  // Permiten leer lo que el usuario escribió en cada campo.
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  // Se ejecuta al cerrar la pantalla: libera la memoria de los controladores.
  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // ---------- Acciones ----------
  // Se llama al presionar "Ingresar" (o Enter en el campo de contraseña).
  Future<void> _onLogin() async {
    // context.read: usa el ViewModel una sola vez, sin escuchar cambios.
    final ok = await context.read<LoginViewModel>().login(
          _emailCtrl.text,
          _passCtrl.text,
        );
    if (!ok || !mounted) return; // si falló o la pantalla se cerró, no hacer nada

    // pushReplacement reemplaza el login por el Home: al presionar "atrás"
    // en el Home no se vuelve al login.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeView()),
    );
  }

  // Estilo reutilizable para los dos campos: fondo blanco, esquinas redondeadas,
  // icono a la izquierda y borde naranja al enfocar.
  InputDecoration _decoration(String label, IconData icon) {
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: width),
        );
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: border(AppColors.outlineVariant, 1),
      enabledBorder: border(AppColors.outlineVariant, 1),
      focusedBorder: border(AppColors.primary, 1.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    );
  }

  // ---------- Interfaz ----------
  @override
  Widget build(BuildContext context) {
    // context.watch: escucha al ViewModel; si cambia (isLoading, errorMessage)
    // esta pantalla se redibuja automáticamente.
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      body: SafeArea(
        // SafeArea evita que el contenido quede bajo la barra de estado
        child: Align(
          // Posición vertical: -1 = arriba del todo, 0 = centro, 1 = abajo
          alignment: const Alignment(0, -0.6),
          // SingleChildScrollView: permite hacer scroll cuando sale el teclado
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ocupa solo el espacio necesario
              crossAxisAlignment: CrossAxisAlignment.start, // alinea a la izquierda
              children: [
                // ----- Logo -----
                Center(child: Image.asset('assets/images/logo.png', width: 220)),
                const SizedBox(height: 28),

                // ----- Título y subtítulo -----
                const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                ),
                const Text('¡Bienvenido repartidor!', style: TextStyle(fontSize: 14)),
                const SizedBox(height: 26),

                // ----- Campo: correo electrónico -----
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress, // teclado con @
                  textInputAction: TextInputAction.next, // Enter pasa al siguiente campo
                  decoration: _decoration('Correo electrónico', Icons.mail_outline),
                ),
                const SizedBox(height: 20),

                // ----- Campo: contraseña -----
                TextField(
                  controller: _passCtrl,
                  obscureText: true, // oculta lo escrito (••••)
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _onLogin(), // Enter = presionar "Ingresar"
                  decoration: _decoration('Contraseña', Icons.lock_outline),
                ),

                // ----- Mensaje de error (solo se muestra si hay uno) -----
                if (vm.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.urgentBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, size: 18, color: AppColors.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            vm.errorMessage!,
                            style: const TextStyle(color: AppColors.error, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 28),

                // ----- Botón "Ingresar" (con sombra) -----
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                    ],
                  ),
                  child: FilledButton(
                    // Deshabilitado (null) mientras carga, para evitar doble envío
                    onPressed: vm.isLoading ? null : _onLogin,
                    child: vm.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Ingresar'),
                  ),
                ),
                const SizedBox(height: 8),

                // ----- Enlace "Olvidé mi contraseña" -----
                Center(
                  child: TextButton(
                    onPressed: () {
                      // TO DO: Recuperación de contraseña
                    },
                    child: const Text('Olvidé mi contraseña', style: TextStyle(fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
