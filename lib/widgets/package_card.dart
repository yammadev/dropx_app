import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/package_model.dart';

// Tarjeta de una guía dentro de las listas.
// Si la guía es urgente se pinta en rojo claro con un icono de alerta.
class PackageCard extends StatelessWidget {
  final PackageModel package;
  final VoidCallback? onTap; // se usará para abrir el detalle (en otro paso)

  const PackageCard({super.key, required this.package, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isUrgent = package.isUrgent;
    const addressStyle = TextStyle(fontSize: 12, color: AppColors.textSecondary);

    return Material(
      color: isUrgent ? AppColors.urgentBackground : AppColors.cardBackground,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // ----- Icono de alerta (solo urgentes) -----
              if (isUrgent) ...[
                const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 28),
                const SizedBox(width: 10),
              ],

              // ----- Textos: etiqueta, número de guía y direcciones -----
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Etiqueta - Urgente
                    if (isUrgent)
                      const Text(
                        'Urgente',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                        ),
                      ),
                    
                    // Guía #
                    Text(
                      'Guía #${package.number}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),

                    // Direcciones
                    Text(
                      package.originAddress,
                      style: addressStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // corta con "..." si no cabe
                    ),
                    Text(
                      '↳ ${package.destinationAddress}  •  ${package.distanceKm.toStringAsFixed(1)} Km',
                      style: addressStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // ----- Peso -----
              Text(
                '${package.weightKg.toStringAsFixed(1)} KG',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
