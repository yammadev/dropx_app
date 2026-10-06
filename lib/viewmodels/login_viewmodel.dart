import 'package:flutter/foundation.dart';

// ViewModel del login: guarda el estado y la lógica de la pantalla,
// pero NO dibuja nada (eso es trabajo de LoginView).
// Al extender ChangeNotifier, la vista puede "escucharlo" y redibujarse
// cada vez que llamemos a notifyListeners().
class LoginViewModel extends ChangeNotifier {
  // ---------- Estado ----------
  bool _isLoading = false; // true mientras se espera la respuesta de la API
  String? _errorMessage; // mensaje de error a mostrar (null = sin error)

  // Getters: la vista lee el estado, pero no puede modificarlo directamente
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ---------- Acciones ----------
  /// Intenta iniciar sesión. Devuelve true si salió bien.
  Future<bool> login(String email, String password) async {
    
    // TO DO: Enviar correo y contraseña a la API (POST /api/auth/login).
    // - Poner _isLoading en true y avisar a la vista (notifyListeners).
    // - Si responde bien: guardar el token JWT y devolver true.
    // - Si falla: guardar el mensaje en _errorMessage y devolver false.
    // - Al terminar: poner _isLoading en false y avisar a la vista otra vez.

    // Mientras tanto: no se validan credenciales, siempre "funciona".
    return true;
  }
}