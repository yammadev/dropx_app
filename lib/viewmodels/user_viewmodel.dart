import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

// ViewModel del usuario: guarda quién inició sesión y cierra la sesión.
class UserViewModel extends ChangeNotifier {
  final _api = ApiService();

  // ---------- Estado ----------
  // Vacío hasta que se inicia sesión (lo llena el login con los datos de la API).
  static const _emptyUser = UserModel(name: '', email: '', role: 'courier');
  UserModel _user = _emptyUser;

  // Getter: la vista lee el usuario, pero no puede modificarlo
  UserModel get user => _user;

  // ---------- Acciones ----------
  /// Guarda el usuario que devolvió la API al iniciar sesión.
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  /// Cierra la sesión del repartidor: borra el token y los datos del usuario.
  Future<void> logout() async {
    await _api.clearToken();
    _user = _emptyUser;
    notifyListeners();
  }
}
