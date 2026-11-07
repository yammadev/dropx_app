import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../models/package_model.dart';
import '../viewmodels/packages_viewmodel.dart';
import 'signature_dialog.dart';

// Botones de la parte inferior del detalle para cambiar el estado de la guía:
// pendiente -> recogida -> entregada, o reportar una novedad.
// Las guías entregadas ya no se pueden cambiar (no muestra nada).
class StatusActions extends StatelessWidget {
  final PackageModel package;

  const StatusActions({super.key, required this.package});

  // Motivos para reportar una novedad
  static const _reasons = [
    'Destinatario ausente',
    'Dirección incorrecta o no encontrada',
    'Destinatario rechazó el paquete',
    'Paquete dañado',
    'Teléfono sin respuesta',
    'Otro motivo',
  ];

  // Lista de motivos: al tocar uno se selecciona
  Future<String?> _askReason(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Motivo de la novedad'),
        children: [
          for (final reason in _reasons)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, reason),
              child: Text(reason),
            ),
        ],
      ),
    );
  }

  // Pregunta "¿...?" con Cancelar y Confirmar
  Future<bool> _confirm(BuildContext context, String question) async {
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
    return confirmed ?? false;
  }

  // Pide lo que cada cambio necesita: el motivo (novedad), la firma (entrega) o una confirmación.
  // Si sale bien, vuelve a la lista y avisa con un mensaje.
  Future<void> _change(BuildContext context, PackageStatus status, String question) async {
    String? reason;
    Uint8List? signature;

    if (status == PackageStatus.problem) {
      reason = await _askReason(context);
      if (reason == null) return;
    } else if (status == PackageStatus.delivered) {
      signature = await showDialog<Uint8List>(context: context, builder: (_) => const SignatureDialog());
      if (signature == null) return;
    } else if (!await _confirm(context, question)) {
      return;
    }
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final error = await context.read<PackagesViewModel>().changeStatus(
          package,
          status,
          reason: reason,
          signature: signature,
        );
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
      _ => ('Marcar como entregada', PackageStatus.delivered, ''), // pide la firma, no confirmación
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
                      : () => _change(context, PackageStatus.problem, ''),
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
