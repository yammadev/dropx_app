import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api_config.dart';

// Enlaces que la app abre fuera de ella: páginas de la web (Suite) y Google Maps.
class Links {
  Links._(); // Evita crear instancias, solo se usan sus funciones

  // Página de la Suite web, en el mismo servidor de la API (API_URL del .env).
  // Ej: Links.suite('recuperar') -> https://.../suite/recuperar
  static Uri suite(String page) => Uri.parse('${ApiConfig.baseUrl}/suite/$page');

  // Abre el enlace en otra aplicación (navegador o Google Maps).
  // Si no se puede abrir, muestra [errorMessage] en un aviso en la parte de abajo.
  static Future<void> open(BuildContext context, Uri url, String errorMessage) async {
    final opened = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }
}
