import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/package_model.dart';
import 'detail_card.dart';

// Tarjeta RUTA del detalle: origen, destino, peso, distancia y botón del mapa.
// Se ve igual para todas las guías, sean urgentes o no.
class RouteCard extends StatelessWidget {
  final PackageModel package;

  const RouteCard({super.key, required this.package});

  // Una parada de la ruta: icono en círculo, etiqueta (ORIGEN / DESTINO) y dirección
  Widget _buildStop({
    required Widget icon,
    required Color iconBackground,
    required String label,
    required String address,
    Border? border,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconBackground,
            shape: BoxShape.circle,
            border: border,
          ),
          child: Center(child: icon),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(address, style: const TextStyle(fontSize: 14, height: 19 / 14)),
            ],
          ),
        ),
      ],
    );
  }

  // Recuadro con un dato grande (peso o distancia)
  Widget _buildTile(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'RUTA',
      child: Column(
        children: [
          _buildStop(
            icon: const Icon(Icons.trip_origin, size: 16, color: AppColors.textSecondary),
            iconBackground: Colors.white,
            border: Border.all(color: AppColors.outlineVariant, width: 1.5),
            label: 'ORIGEN',
            address: package.originAddress,
          ),
          const SizedBox(height: 12),
          _buildStop(
            icon: const Icon(Icons.location_on, size: 18, color: AppColors.primary),
            iconBackground: AppColors.pillBackground,
            label: 'DESTINO',
            address: package.destinationAddress,
          ),
          const SizedBox(height: 14),

          // Peso y distancia
          Row(
            children: [
              _buildTile(
                Icons.scale_outlined,
                '${package.weightKg.toStringAsFixed(1)} kg',
                'Peso',
              ),
              const SizedBox(width: 10),
              _buildTile(
                Icons.route_outlined,
                '${package.distanceKm.toStringAsFixed(1)} km',
                'Distancia',
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Botón para ver la ruta en el mapa (sólo UI por ahora)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // TO DO: Abrir el mapa con la ruta de origen a destino.
              },
              icon: const Icon(Icons.directions, size: 20),
              label: const Text('Ver ruta en el mapa'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
