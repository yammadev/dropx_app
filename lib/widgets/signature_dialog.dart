import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

// Ventana para que quien recibe el paquete firme con el dedo.
// Al confirmar devuelve la firma como imagen PNG (o null si se cancela).
class SignatureDialog extends StatefulWidget {
  const SignatureDialog({super.key});

  @override
  State<SignatureDialog> createState() => _SignatureDialogState();
}

class _SignatureDialogState extends State<SignatureDialog> {
  final _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white, // fondo blanco en la imagen
  );

  @override
  void initState() {
    super.initState();
    // Redibuja para activar o desactivar el botón según haya firma o no
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final Uint8List? png = await _controller.toPngBytes();
    if (mounted) Navigator.pop(context, png);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Firma de quien recibe'),
      content: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
        child: Signature(controller: _controller, height: 200, backgroundColor: Colors.white),
      ),
      actions: [
        TextButton(onPressed: _controller.clear, child: const Text('Limpiar')),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(
          onPressed: _controller.isEmpty ? null : _confirm,
          child: const Text('Entregar'),
        ),
      ],
    );
  }
}
