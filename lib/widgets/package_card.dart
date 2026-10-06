import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/package_model.dart';

// Tarjeta de una guía dentro de las listas (estilo "outlined card" de Material 3).
// Muestra: número de guía, la ruta (origen -> destino) y cajitas con
// peso y distancia. Normal: blanca con borde gris. Urgente: rosa con borde rojo
// y una cajita "Urgente".
class PackageCard extends StatelessWidget {
  final PackageModel package;
  final VoidCallback? onTap; // se usará para abrir el detalle (en otro paso)

  const PackageCard({super.key, required this.package, this.onTap});

  // Cajita pequeña con icono y texto (peso, distancia).
  // Gris sobre la tarjeta blanca, blanca sobre la tarjeta rosa (urgente).
  Widget _buildInfoBox(IconData icon, String text, bool onUrgent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: onUrgent ? Colors.white : AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // la cajita mide lo que mide su contenido
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // Cajita roja "Urgente" (solo para guías urgentes)
  Widget _buildUrgentBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, size: 14, color: Colors.white),
          SizedBox(width: 4),
          Text(
            'Urgente',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUrgent = package.isUrgent;

    // Cada línea de dirección mide 18 de alto para alinear con los iconos
    const addressStyle = TextStyle(fontSize: 13, height: 18 / 13, color: AppColors.textPrimary);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: isUrgent ? AppColors.urgentBackground : Colors.white,
      clipBehavior: Clip.antiAlias, // recorta el efecto del toque en las esquinas
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isUrgent ? AppColors.error : AppColors.outlineVariant,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----- Encabezado: número de guía -----
              Text(
                'Guía ${package.number}', // el número ya trae el prefijo, ej: DX152216
                // Estilo "titleMedium" del tema de Material 3, un poco más grueso
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              // ----- Ruta: iconos de origen y destino con sus direcciones -----
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna de iconos: círculo (origen) y pin (destino)
                  const Column(
                    children: [
                      SizedBox(
                        height: 18,
                        width: 18,
                        child: Icon(Icons.radio_button_unchecked, size: 14, color: AppColors.textSecondary),
                      ),
                      SizedBox(height: 8), // mismo espacio que hay entre las dos direcciones
                      SizedBox(
                        height: 18,
                        width: 18,
                        child: Icon(Icons.location_on, size: 18, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),

                  // Columna de direcciones
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.originAddress,
                          style: addressStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // corta con "..." si no cabe
                        ),
                        const SizedBox(height: 8),
                        Text(
                          package.destinationAddress,
                          style: addressStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ----- Cajitas: Urgente (si aplica), peso y distancia -----
              Wrap(
                spacing: 8,
                runSpacing: 6, // si no caben en una línea, pasan a la siguiente
                children: [
                  if (isUrgent) _buildUrgentBox(),
                  _buildInfoBox(Icons.scale_outlined, '${package.weightKg.toStringAsFixed(1)} kg', isUrgent),
                  _buildInfoBox(Icons.route_outlined, '${package.distanceKm.toStringAsFixed(1)} km', isUrgent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}