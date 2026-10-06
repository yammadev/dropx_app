import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/package_model.dart';
import '../widgets/contacts_card.dart';
import '../widgets/route_card.dart';
import '../widgets/status_band.dart';

// Pantalla de detalle de una guía (solo información básica).
// Arma las piezas: encabezado naranja, banda de estado, tarjeta de ruta y de contactos.
class PackageView extends StatelessWidget {
  final PackageModel package;

  const PackageView({super.key, required this.package});

  // ---------- Encabezado naranja: número de guía y, si aplica, "Urgente" ----------
  Widget _buildHero() {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Guía', style: TextStyle(fontSize: 13, color: Colors.white70)),
          Row(
            children: [
              // Número de guía
              Expanded(
                child: Text(
                  package.number,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              // Cajita roja "Urgente" a la derecha (igual a la de las tarjetas)
              if (package.isUrgent)
                Container(
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
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ---------- Barra superior (el color sale del tema) ----------
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 48,
        titleSpacing: 0,
        // Flecha para volver a la lista, sin efecto al tocar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          style: const ButtonStyle(
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
          ),
        ),
        title: const Text('Detalle de guía'),
      ),

      // ---------- Contenido con scroll ----------
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHero(),
            StatusBand(package: package),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  RouteCard(package: package),
                  const SizedBox(height: 12),
                  ContactsCard(sender: package.sender, receiver: package.receiver),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
