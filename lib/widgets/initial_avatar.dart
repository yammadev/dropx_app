import 'package:flutter/material.dart';

import '../core/app_theme.dart';

// Círculo naranja claro con la inicial de un nombre. Lo usan el perfil y los contactos del detalle.
class InitialAvatar extends StatelessWidget {
  final String name;
  final double radius; // tamaño del círculo
  final double fontSize; // tamaño de la letra
  final FontWeight fontWeight;

  const InitialAvatar({
    super.key,
    required this.name,
    required this.radius,
    required this.fontSize,
    this.fontWeight = FontWeight.w700,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.pillBackground,
      child: Text(
        initial,
        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: AppColors.primary),
      ),
    );
  }
}
