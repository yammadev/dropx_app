import 'package:flutter/foundation.dart';

import '../models/package_model.dart';
import '../services/api_service.dart';

// ViewModel de las guías: guarda las tres listas que muestra el Home.
class PackagesViewModel extends ChangeNotifier {
  final _api = ApiService();

  // ---------- Estado ----------
  List<PackageModel> _pending = [];
  List<PackageModel> _inTransit = []; // incluye las guías con novedad
  List<PackageModel> _delivered = [];
  bool _isLoading = false; // true mientras se cargan las guías
  String? _errorMessage; // mensaje de error a mostrar (null = sin error)

  // Getters: la vista lee las listas, pero no puede modificarlas
  List<PackageModel> get pending => _pending;
  List<PackageModel> get inTransit => _inTransit;
  List<PackageModel> get delivered => _delivered;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Resumen para el encabezado de Pendientes
  int get urgentPendingCount => _pending.where((p) => p.isUrgent).length;
  double get pendingDistanceKm => _pending.fold(0.0, (sum, p) => sum + p.distanceKm);
  int get deliveredCount => _delivered.length;
  int get totalCount => _pending.length + _inTransit.length + _delivered.length;

  // ---------- Acciones ----------
  /// Carga las guías asignadas al repartidor (GET /api/packages).
  Future<void> loadPackages() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final packages = await _api.getPackages();

      // Se reparten en las tres pestañas según su estado
      _pending = packages.where((p) => p.status == PackageStatus.pending).toList();
      _inTransit = packages
          .where((p) => p.status == PackageStatus.inTransit || p.status == PackageStatus.problem)
          .toList();
      _delivered = packages.where((p) => p.status == PackageStatus.delivered).toList();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Vacía las listas (al cerrar sesión).
  void clear() {
    _pending = [];
    _inTransit = [];
    _delivered = [];
    _errorMessage = null;
    notifyListeners();
  }

  // TO DO: Cambiar el estado de una guía (recoger, entregar, reportar novedad).
}
