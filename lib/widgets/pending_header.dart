import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../viewmodels/packages_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';

// Encabezado de la pestaña Pendientes (la pantalla de inicio):
// saludo, mensaje con el contador, cajitas de resumen y tarjeta de progreso.
// La tarjeta de progreso se monta sobre el borde inferior del bloque naranja.
class PendingHeader extends StatelessWidget {
  const PendingHeader({super.key});

  static const _cardHeight = 80.0; // alto de la tarjeta de progreso
  static const _gap = 12.0; // espacio entre la tarjeta de progreso y la primera guía

  // Saludo según la hora del celular
  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Buenos días';
    if (hour >= 12 && hour < 19) return 'Buenas tardes';
    return 'Buenas noches'; // de 7 pm a 4:59 am
  }

  // Cajita de resumen (fondo blanco translúcido, esquinas poco redondeadas)
  Widget _buildBox(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Tarjeta blanca con la barra de progreso (sin sombra)
  Widget _buildProgressCard(int delivered, int total) {
    final progress = total == 0 ? 0.0 : delivered / total;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Text(
                  'Mi Progreso',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    children: [
                      TextSpan(
                        text: '$delivered',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      TextSpan(text: ' de $total entregadas'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Barra: fondo naranja claro y relleno naranja según el progreso
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 8,
                color: AppColors.pillBackground,
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PackagesViewModel>();
    final firstName = context.watch<UserViewModel>().user.name.split(' ').first;

    final count = vm.pending.length;
    final urgent = vm.urgentPendingCount;
    final noun = count == 1 ? 'guía pendiente' : 'guías pendientes';

    const summaryStyle = TextStyle(fontSize: 14, color: Colors.white);

    return Stack(
      children: [
        // Capa de fondo: bloque naranja + espacio para la mitad de la tarjeta
        Column(
          children: [
            Container(
              width: double.infinity,
              // Arriba deja el alto de la barra de estado más un margen (/2)
              padding: EdgeInsets.fromLTRB(20, MediaQuery.paddingOf(context).top + 16, 20, 20 + _cardHeight / 2),
              color: AppColors.primary, // borde inferior recto
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Saludo
                  Text(
                    '$_greeting, $firstName',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Mensaje con el contador
                  count == 0
                      ? const Text('No tienes guías pendientes', style: summaryStyle)
                      : Text.rich(
                          TextSpan(
                            style: summaryStyle,
                            children: [
                              const TextSpan(text: 'Tienes '),
                              TextSpan(
                                text: '$count',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              TextSpan(text: ' $noun'),
                            ],
                          ),
                        ),
                  const SizedBox(height: 12),

                  // Cajitas de resumen
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      if (urgent > 0)
                        _buildBox(
                          Icons.warning_amber_rounded,
                          urgent == 1 ? '1 urgente' : '$urgent urgentes',
                        ),
                      _buildBox(
                        Icons.route_outlined,
                        '${vm.pendingDistanceKm.toStringAsFixed(1)} km en total',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Mitad de la tarjeta + gap (espacio) de aire antes de la primera guía
            const SizedBox(height: _cardHeight / 2 + _gap),
          ],
        ),

        // Tarjeta de progreso, pegada abajo: cubre la mitad del naranja y la mitad del gris
        Positioned(
          left: 16,
          right: 16,
          bottom: _gap, // sube la tarjeta para dejar el espacio debajo
          height: _cardHeight,
          child: _buildProgressCard(vm.deliveredCount, vm.totalCount),
        ),
      ],
    );
  }
}