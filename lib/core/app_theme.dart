import 'package:flutter/material.dart';

// Colores de la marca. Se usan así: AppColors.primary
class AppColors {
  AppColors._(); // Evita crear instancias, solo se usan sus constantes

  static const primary = Color(0xFFFF6600);     // Naranja principal
  static const textPrimary = Color(0xFF1C1B1F); // Texto principal
  static const border = Color(0xFF79747E);      // Borde de los campos
  static const error = Color(0xFFE53935);       // Mensajes de error
  static const textSecondary = Color(0xFF5F5F5F);     // Textos pequeños (direcciones)
  static const urgentBackground = Color(0xFFFDE8E6);  // Fondo de tarjeta urgente
  static const cardBackground = Color(0xFFF3F3F3);    // Fondo de tarjeta normal
  static const pillBackground = Color(0xFFFFE4D0);    // Indicador de la barra inferior
}

// Tema global de la app. Se aplica en MaterialApp (main.dart).
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,

        // Paleta general generada a partir del naranja de la marca
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: Colors.white, // Barra superior blanca
        ),

        // Fondo de todas las pantallas
        scaffoldBackgroundColor: Colors.white,

        // Estilo de los FilledButton (Botón naranja redondeado)
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(60), // alto del botón
            shape: const StadiumBorder(), // bordes totalmente redondeados
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),

        // Estilo de los TextButton (ej: "Olvidé mi contraseña")
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppColors.textPrimary),
        ),
      );
}
