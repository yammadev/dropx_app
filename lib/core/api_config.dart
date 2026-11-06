// Configuración de la conexión con la API (backend Flask).
class ApiConfig {
  // Dirección de la API según dónde se ejecute la app:
  // - Emulador de Android: 10.0.2.2 (es el "localhost" de la computadora).
  // - Celular real: la IP de la computadora en la red, ej: http://192.168.1.10:5000
  static const baseUrl = '192.168.1.15:5000';

  // Tiempo máximo de espera de una respuesta
  static const timeout = Duration(seconds: 15);
}
