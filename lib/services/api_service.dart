import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api_config.dart';
import '../models/package_model.dart';
import '../models/user_model.dart';

// Error de la API con un mensaje listo para mostrar al usuario.
class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
}

// Único lugar de la app que habla con la API (los ViewModels lo usan).
class ApiService {
  static const _tokenKey = 'token';

  // ---------- Token JWT ----------
  // Se guarda en el teléfono para poder enviarlo en cada petición.
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> readToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ---------- Peticiones ----------
  /// POST /api/auth/login. Guarda el token y devuelve el usuario.
  Future<UserModel> login(String email, String password) async {
    final data = await _send(
      () => http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.trim(), 'password': password}),
      ),
    );

    // Esta app es solo para repartidores
    final user = UserModel.fromJson(data['user']);
    if (user.role != 'courier') {
      throw const ApiException('Esta cuenta no es de repartidor. Use la Suite web.');
    }
    await saveToken(data['token']);
    return user;
  }

  /// GET /api/packages. Devuelve las guías asignadas al repartidor.
  Future<List<PackageModel>> getPackages() async {
    final token = await readToken();
    if (token == null) {
      throw const ApiException('La sesión no está iniciada.');
    }

    final data = await _send(
      () => http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/packages'),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    return (data['packages'] as List).map((item) => PackageModel.fromJson(item)).toList();
  }

  /// PATCH /api/packages/<id>/status. Cambia el estado y devuelve la guía actualizada.
  Future<PackageModel> changeStatus(int packageId, PackageStatus status) async {
    final token = await readToken();
    if (token == null) {
      throw const ApiException('La sesión no está iniciada.');
    }

    final data = await _send(
      () => http.patch(
        Uri.parse('${ApiConfig.baseUrl}/api/packages/$packageId/status'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({'status': status.apiValue}),
      ),
    );
    return PackageModel.fromJson(data['package']);
  }

  // ---------- Ayuda interna ----------
  // Mensaje cuando no se logra llegar al servidor; incluye la dirección usada para ayudar a corregirla.
  String get _noConnection =>
      'No hay conexión con el servidor (${ApiConfig.baseUrl}). Verifique que la API esté en ejecución y que API_URL en el archivo .env sea correcta.';

  // Ejecuta la petición, convierte la respuesta a JSON y traduce los errores
  // (sin conexión, tiempo agotado, 401...) a mensajes en español.
  Future<Map<String, dynamic>> _send(Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(ApiConfig.timeout);
      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) return body;

      // La API manda el motivo en "message" (ya está en español)
      throw ApiException(body['message'] ?? 'Ocurrió un error. Intente de nuevo.');
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw ApiException('El servidor tardó demasiado en responder (${ApiConfig.baseUrl}).');
    } on SocketException {
      throw ApiException(_noConnection);
    } on http.ClientException {
      throw ApiException(_noConnection);
    } on FormatException {
      // El servidor respondió algo que no es JSON (por ejemplo, una página de error)
      throw ApiException('La respuesta del servidor no es válida. Revise la dirección de la API (${ApiConfig.baseUrl}).');
    } catch (error) {
      debugPrint('Error inesperado en la API: $error'); // se ve en la consola de Flutter
      throw const ApiException('No se pudo completar la solicitud.');
    }
  }
}
