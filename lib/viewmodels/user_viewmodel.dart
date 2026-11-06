import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

// ViewModel del usuario: guarda quién inició sesión y cierra la sesión.
class UserViewModel extends ChangeNotifier {
  // ---------- Estado ----------
  // Datos de ejemplo. Se reemplazan por los que devuelve la API al iniciar sesión.
  final UserModel _user = const UserModel(
    name: 'Jhon Doe',
    email: 'courier@dropx.com',
  );

  // Getter: la vista lee el usuario, pero no puede modificarlo
  UserModel get user => _user;

  // ---------- Acciones ----------
  // TO DO: Guardar el usuario con los datos que devuelve la API al iniciar
  // sesión (user: name, email). El campo _user deja de ser `final`.

  /// Cierra la sesión del repartidor.
  Future<void> logout() async {
    // TO DO: Borrar el token JWT guardado y los datos del usuario.
  }
}
