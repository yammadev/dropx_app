import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

// ViewModel del login: guarda el estado y la lógica de la pantalla,
// pero NO dibuja nada (eso es trabajo de LoginView).
// Al extender ChangeNotifier, la vista puede "escucharlo" y redibujarse
// cada vez que llamemos a notifyListeners().
class LoginViewModel extends ChangeNotifier {
  final _api = ApiService();

  // ---------- Estado ----------
  bool _isLoading = false; // true mientras se espera la respuesta de la API
  String? _errorMessage; // mensaje de error a mostrar (null = sin error)
  UserModel? _user; // repartidor que inició sesión (lo usa la vista para llenar el perfil)

  // Getters: la vista lee el estado, pero no puede modificarlo directamente
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;

  // ---------- Acciones ----------
  /// Intenta iniciar sesión. Devuelve true si salió bien.
  Future<bool> login(String email, String password) async {
    if (email.trim().isEmpty || password.isEmpty) {
      _errorMessage = 'Ingrese su correo y su contraseña.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // POST /api/auth/login: la API guarda el token y devuelve el usuario
      _user = await _api.login(email, password);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } finally {
      // Se ejecuta siempre, haya salido bien o mal
      _isLoading = false;
      notifyListeners();
    }
  }
}
