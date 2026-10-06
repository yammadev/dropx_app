import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // SystemUiOverlayStyle

// Colores de la marca. Se usan así: AppColors.primary
class AppColors {
  AppColors._(); // Evita crear instancias, solo se usan sus constantes

  static const primary = Color(0xFFFF6600);     // Naranja principal
  static const textPrimary = Color(0xFF1C1B1F); // Texto principal
  static const border = Color(0xFF79747E);      // Borde de los campos
  static const outlineVariant = Color(0xFFCAC4D0);    // Borde suave de las tarjetas (Material 3)
  static const error = Color(0xFFE53935);       // Mensajes de error
  static const info = Color(0xFF1E88E5);        // Estado: recogido
  static const success = Color(0xFF2E9E5B);     // Estado: entregado
  static const problem = Color(0xFF7B3FA0);     // Estado: con novedad
  static const textSecondary = Color(0xFF5F5F5F);     // Textos pequeños (direcciones)
  static const urgentBackground = Color(0xFFFDE8E6);  // Fondo rosa de la tarjeta urgente
  static const background = Color(0xFFF4F4F4);        // Fondo gris tenue de las pantallas
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
          surface: Colors.white, // Fondo blanco de superficies (hojas, diálogos, etc.)
        ),

        // Fondo de todas las pantallas (gris tenue; las tarjetas van en blanco encima)
        scaffoldBackgroundColor: AppColors.background,

        // Barra superior naranja con título e iconos blancos
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          scrolledUnderElevation: 0, // evita que cambie de color al hacer scroll
          systemOverlayStyle: SystemUiOverlayStyle.light, // iconos blancos en la barra de estado
        ),

        // Barra inferior con el estilo de Material 3
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          elevation: 0,
          indicatorColor: AppColors.primary, // "píldora" naranja detrás del icono activo
          // Icono: blanco (sobre la píldora naranja) si está activo, gris si no
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? Colors.white
                  : AppColors.textSecondary,
            ),
          ),
          // Nombre: más grueso y oscuro si está activo
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontSize: 12,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w600
                  : FontWeight.w500,
              color: states.contains(WidgetState.selected)
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ),

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