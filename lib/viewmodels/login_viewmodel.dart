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
    // ---------------- FASE API (comentado) ----------------
    // _isLoading = true;
    // _errorMessage = null;
    // notifyListeners(); // avisa a la vista: muestra el spinner
    //
    // try {
    //   // AuthService hace POST /api/auth/login y guarda el JWT
    //   await _authService.login(email.trim(), password);
    //   return true;
    // } catch (e) {
    //   _errorMessage = e.toString().replaceFirst('Exception: ', '');
    //   return false;
    // } finally {
    //   _isLoading = false;
    //   notifyListeners(); // avisa a la vista: quita el spinner / muestra error
    // }
    // ------------------------------------------------------

    // Mientras tanto: no se validan credenciales, siempre "funciona".
    return true;
  }
}
