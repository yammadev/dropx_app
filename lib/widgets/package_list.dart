import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/package_model.dart';
import 'package_card.dart';

// Lista de guías reutilizable: la usan las tres pestañas del Home.
class PackageList extends StatelessWidget {
  final List<PackageModel> packages;
  final String statusLabel; // estado en singular, ej: "recogida" (para el contador)
  final bool showDateHeader; // true = muestra además la fecha y el filtro
  final Widget? header; // encabezado propio (ancho completo). Si se da, reemplaza al normal

  const PackageList({
    super.key,
    required this.packages,
    required this.statusLabel,
    this.showDateHeader = false,
    this.header,
  });

  static const _months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
  ];

  // Texto de la fecha, ej: "Hoy - 6 Oct 2026"
  String get _todayLabel {
    final now = DateTime.now();
    return 'Hoy - ${now.day} ${_months[now.month - 1]} ${now.year}';
  }

  // ---------- Mensaje con el contador ----------
  // Ej: "Tienes 3 guías recogidas" (el número va grande y en naranja).
  Widget _buildSummary() {
    const style = TextStyle(fontSize: 15, color: AppColors.textSecondary);
    final count = packages.length;

    if (count == 0) {
      return Text('No tienes guías ${statusLabel}s', style: style);
    }

    final noun = count == 1 ? 'guía $statusLabel' : 'guías ${statusLabel}s';
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          const TextSpan(text: 'Tienes '),
          TextSpan(
            text: '$count',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          TextSpan(text: ' $noun'),
        ],
      ),
    );
  }

  // ---------- Encabezado normal: mensaje, fecha y filtro ----------
  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummary(),
              // Fecha (solo Recogidos y Entregados)
              if (showDateHeader)
                Text(
                  _todayLabel,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
            ],
          ),
        ),
        // Botón de filtro (solo Recogidos y Entregados)
        if (showDateHeader)
          IconButton(
            icon: const Icon(Icons.filter_list),
            style: IconButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              // TO DO: Filtrar por fecha
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Si no hay guías se muestra el encabezado y un mensaje debajo
    final itemCount = packages.isEmpty ? 2 : packages.length + 1;

    return ListView.separated(
      // Sin margen lateral: el encabezado propio ocupa todo el ancho,
      // y los demás elementos llevan su margen de 16 por separado.
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 10), // espacio entre tarjetas
      itemBuilder: (context, index) {
        if (index == 0) {
          return header ??
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 16, 0),
                child: _buildHeader(),
              );
        }

        if (packages.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 48),
            child: Center(child: Text('No hay guías')),
          );
        }

        final package = packages[index - 1];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PackageCard(
            package: package,
            onTap: () {
              // TO DO: Abrir el detalle de la guía
            },
          ),
        );
      },
    );
  }
}
