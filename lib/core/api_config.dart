import 'package:flutter_dotenv/flutter_dotenv.dart';

// Configuración de la conexión con la API (backend Flask).
// Los valores salen del archivo .env (el modelo es .env.example).
class ApiConfig {
  // Dirección de la API (API_URL). Si falta, se usa la del emulador de Android
  // (10.0.2.2 es el "localhost" de la computadora).
  static String get baseUrl {
    final url = dotenv.env['API_URL'] ?? 'http://10.0.2.2:5000';
    return url.trim().replaceAll(RegExp(r'/+$'), ''); // quita "/" sobrantes al final
  }

  // Tiempo máximo de espera de una respuesta (API_TIMEOUT_SECONDS)
  static Duration get timeout {
    final seconds = int.tryParse(dotenv.env['API_TIMEOUT_SECONDS'] ?? '') ?? 15;
    return Duration(seconds: seconds);
  }
}
