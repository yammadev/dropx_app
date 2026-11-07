import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/packages_viewmodel.dart';

// Botón para volver a cargar las guías (la app no recibe avisos en tiempo real,
// así que el repartidor la usa para ver si le asignaron guías nuevas).
// Mientras carga, el icono se cambia por un indicador giratorio.
class RefreshButton extends StatelessWidget {
  const RefreshButton({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PackagesViewModel>();

    return IconButton(
      tooltip: 'Recargar',
      onPressed: vm.isLoading ? null : vm.loadPackages,
      icon: vm.isLoading
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Icon(Icons.refresh, color: Colors.white),
    );
  }
}
