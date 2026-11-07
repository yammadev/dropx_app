import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../models/package_model.dart';
import '../viewmodels/packages_viewmodel.dart';

// Botones de la parte inferior del detalle para cambiar el estado de la guía:
// pendiente -> recogida -> entregada, o reportar una novedad.
// Las guías entregadas ya no se pueden cambiar (no muestra nada).
class StatusActions extends StatelessWidget {
  final PackageModel package;

  const StatusActions({super.key, required this.package});

  // Pregunta antes de cambiar. Si sale bien, vuelve a la lista y avisa con un mensaje.
  Future<void> _change(BuildContext context, PackageStatus status, String question) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Guía ${package.number}'),
        content: Text(question),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final error = await context.read<PackagesViewModel>().changeStatus(package, status);
    if (!context.mounted) return;

    if (error == null) {
      Navigator.pop(context); // vuelve a la lista (ya recargada)
      messenger.showSnackBar(const SnackBar(content: Text('Estado actualizado.')));
    } else {
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (package.status == PackageStatus.delivered) return const SizedBox.shrink();

    final isUpdating = context.watch<PackagesViewModel>().isUpdating;

    // Acción principal según el estado actual
    final (label, target, question) = switch (package.status) {
      PackageStatus.pending => ('Marcar como recogida', PackageStatus.inTransit, '¿Ya recogiste esta guía?'),
      PackageStatus.problem => ('Retomar entrega', PackageStatus.inTransit, '¿Retomar la entrega de esta guía?'),
      _ => ('Marcar como entregada', PackageStatus.delivered, '¿Ya entregaste esta guía?'),
    };

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                onPressed: isUpdating ? null : () => _change(context, target, question),
                child: isUpdating
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(label),
              ),
              // Una guía con novedad ya la reportó; solo puede retomarla
              if (package.status != PackageStatus.problem) ...[
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: AppColors.error,
                  ),
                  onPressed: isUpdating
                      ? null
                      : () => _change(context, PackageStatus.problem, '¿Reportar una novedad con esta guía?'),
                  child: const Text('Reportar novedad'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
