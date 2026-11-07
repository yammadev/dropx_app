// Datos del repartidor que inició sesión.
// La contraseña nunca se guarda aquí.
class UserModel {
  final String name;
  final String email;
  final String role; // admin, manager o courier (en la app solo entra courier)

  const UserModel({required this.name, required this.email, required this.role});

  // Crea el usuario a partir del JSON de la API: {"id": 3, "name": "...", ...}
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'],
        email: json['email'],
        role: json['role'],
      );
}
