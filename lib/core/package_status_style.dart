import 'package:flutter/material.dart';

import '../models/package_model.dart';
import 'app_theme.dart';

// Texto, icono y color de cada estado de guía.
// Se usa en la banda del detalle y, más adelante, en las listas.
extension PackageStatusStyle on PackageStatus {
  String get label => switch (this) {
        PackageStatus.pending => 'Pendiente',
        PackageStatus.inTransit => 'Recogido',
        PackageStatus.delivered => 'Entregado',
        PackageStatus.problem => 'Con novedad',
      };

  IconData get icon => switch (this) {
        PackageStatus.pending => Icons.info_outline,
        PackageStatus.inTransit => Icons.explore_outlined,
        PackageStatus.delivered => Icons.check,
        PackageStatus.problem => Icons.warning_amber_rounded,
      };

  Color get color => switch (this) {
        PackageStatus.pending => AppColors.error,
        PackageStatus.inTransit => AppColors.info,
        PackageStatus.delivered => AppColors.success,
        PackageStatus.problem => AppColors.problem,
      };
}
