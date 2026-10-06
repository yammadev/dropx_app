import 'package:flutter/material.dart';

import '../core/package_status_style.dart';
import '../models/package_model.dart';

// Banda de estado del detalle: a todo el ancho y del color del estado.
// Muestra el estado en mayúsculas y la fecha de la última actualización.
class StatusBand extends StatelessWidget {
  final PackageModel package;

  const StatusBand({super.key, required this.package});

  // Fecha con el formato: 21-09-2026 | 07:00 H
  String get _updatedLabel {
    String two(int n) => n.toString().padLeft(2, '0');
    final d = package.updatedAt;
    return '${two(d.day)}-${two(d.month)}-${d.year} | ${two(d.hour)}:${two(d.minute)} H';
  }

  @override
  Widget build(BuildContext context) {
    final status = package.status;

    return Container(
      width: double.infinity,
      color: status.color,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          // Círculo blanco con el icono del estado
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(status.icon, size: 20, color: status.color),
          ),
          const SizedBox(width: 12),
          // Estado en mayúsculas y fecha de la última actualización
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Actualizada $_updatedLabel',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
