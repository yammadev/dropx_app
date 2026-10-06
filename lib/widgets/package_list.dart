import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/package_model.dart';
import 'package_card.dart';

// Lista de guías reutilizable: la usan las tres pestañas del Home.
class PackageList extends StatelessWidget {
  final List<PackageModel> packages;
  final bool showDateHeader; // true = muestra "Hoy - fecha" y el filtro arriba

  const PackageList({
    super.key,
    required this.packages,
    this.showDateHeader = false,
  });

  static const _months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
  ];

  // Texto del encabezado, ej: "Hoy - 5 Oct 2026"
  String get _todayLabel {
    final now = DateTime.now();
    return 'Hoy - ${now.day} ${_months[now.month - 1]} ${now.year}';
  }

  // ---------- Encabezado con fecha y botón de filtro ----------
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 4, 0, 4),
      child: Row(
        children: [
          Text(_todayLabel, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.textPrimary),
            visualDensity: VisualDensity.compact,
            onPressed: () {
              // TO DO: Filtrar por fecha
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (packages.isEmpty) {
      return const Center(child: Text('No hay guías'));
    }

    // Si hay encabezado, ocupa la posición 0 y las guías se corren una posición
    final offset = showDateHeader ? 1 : 0;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: packages.length + offset,
      separatorBuilder: (_, _) => const SizedBox(height: 10), // espacio entre tarjetas
      itemBuilder: (context, index) {
        if (showDateHeader && index == 0) return _buildHeader();

        final package = packages[index - offset];
        return PackageCard(
          package: package,
          onTap: () {
            // TO DO: Abrir el detalle de la guía
          },
        );
      },
    );
  }
}
