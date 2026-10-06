import 'package:flutter/foundation.dart';

import '../models/package_model.dart';

// ViewModel de las guías: guarda las tres listas que muestra el Home.
class PackagesViewModel extends ChangeNotifier {
  // ---------- Estado ----------
  // Datos de ejemplo. Se reemplazan por los de la API en la fase de conexión.
  static const _sender = ContactModel(
    name: 'Harry Cruz López',
    document: 'CC 1.100.000.000',
    phone: '300 500 00 00',
  );
  static const _receiver = ContactModel(
    name: 'Laura Gómez Pérez',
    document: 'CC 1.045.000.000',
    phone: '311 200 00 00',
  );
  static final _pendingDate = DateTime(2026, 9, 21, 7, 0);
  static final _inTransitDate = DateTime(2026, 10, 6, 8, 30);
  static final _deliveredDate = DateTime(2026, 10, 6, 9, 15);
  static final _problemDate = DateTime(2026, 10, 6, 10, 5);

  final List<PackageModel> _pending = [
    PackageModel(
      number: 'DX-152216', weightKg: 10.0, isUrgent: true, status: PackageStatus.pending,
      originAddress: 'Cr # 1 - Cl 15 - B/ Bocagrande',
      destinationAddress: 'Cl 24 Cra 10b - B/ Getsemaní', distanceKm: 3.2,
      sender: _sender, receiver: _receiver, updatedAt: _pendingDate,
    ),
    PackageModel(
      number: 'DX-152222', weightKg: 5.5, isUrgent: true, status: PackageStatus.pending,
      originAddress: 'Cl Larga Cr 10c - B/ Getsemaní',
      destinationAddress: 'Tv 40 Dg 24 - B/ Bruselas', distanceKm: 4.9,
      sender: _sender, receiver: _receiver, updatedAt: _pendingDate,
    ),
    PackageModel(
      number: 'DX-153255', weightKg: 15.5, status: PackageStatus.pending,
      originAddress: 'Tv 69A Cl 31E Lt 3 - B/ 13 de Junio',
      destinationAddress: 'Cra 121 Cl 23 Lt 2 - B/ El Rodeo', distanceKm: 5.4,
      sender: _sender, receiver: _receiver, updatedAt: _pendingDate,
    ),
    PackageModel(
      number: 'DX-153305', weightKg: 2.5, status: PackageStatus.pending,
      originAddress: 'Cr 80 #15-140 - B/ Villa Rubia',
      destinationAddress: 'Dg 28 A #55b-2 A - B/ Ceballos', distanceKm: 2.9,
      sender: _sender, receiver: _receiver, updatedAt: _pendingDate,
    ),
    PackageModel(
      number: 'DX-163355', weightKg: 22.5, status: PackageStatus.pending,
      originAddress: 'Tv 47 #23a-107 - B/ Los Calamares',
      destinationAddress: 'Cl 29d #21A - B/ Pie de la Popa', distanceKm: 5.2,
      sender: _sender, receiver: _receiver, updatedAt: _pendingDate,
    ),
    PackageModel(
      number: 'DX-163356', weightKg: 3.8, status: PackageStatus.pending,
      originAddress: 'Cl 49 # 13-113 - B/ Torices',
      destinationAddress: 'M8 Via al mar - B/ Serena del Mar', distanceKm: 12.5,
      sender: _sender, receiver: _receiver, updatedAt: _pendingDate,
    ),
  ];

  final List<PackageModel> _inTransit = [
    PackageModel(
      number: 'DX-142156', weightKg: 18.2, isUrgent: true, status: PackageStatus.inTransit,
      originAddress: 'Dg 32 #80-918 - B/ Beirut',
      destinationAddress: 'Lt 20 Mz 36 Cl 25 - B/ Bellavista', distanceKm: 2.8,
      sender: _sender, receiver: _receiver, updatedAt: _inTransitDate,
    ),
    PackageModel(
      number: 'DX-142356', weightKg: 10.5, status: PackageStatus.inTransit,
      originAddress: 'Dg 32 #80-547 - Parque Heredia Cr Barlovento',
      destinationAddress: 'Mz 132 Lt 9 P 134 - B/ El Socorro', distanceKm: 2.5,
      sender: _sender, receiver: _receiver, updatedAt: _inTransitDate,
    ),
    PackageModel(
      number: 'DX-143564', weightKg: 7.0, status: PackageStatus.inTransit,
      originAddress: 'Cr 83B #37C59 - Parque Heredia Cr Caracoli',
      destinationAddress: 'Cr 49C #28 - B/ Piedra de Bolívar', distanceKm: 5.0,
      sender: _sender, receiver: _receiver, updatedAt: _inTransitDate,
    ),
    // Guía con novedad (ej: destinatario ausente). Se muestra junto a las recogidas.
    PackageModel(
      number: 'DX-143570', weightKg: 6.3, status: PackageStatus.problem,
      originAddress: 'Cl 31 #44-12 - B/ Blas de Lezo',
      destinationAddress: 'Cr 52 #21-30 - B/ Olaya Herrera', distanceKm: 4.1,
      sender: _sender, receiver: _receiver, updatedAt: _problemDate,
    ),
  ];

  final List<PackageModel> _delivered = [
    PackageModel(
      number: 'DX-141001', weightKg: 4.2, status: PackageStatus.delivered,
      originAddress: 'Cl 30 #17-20 - B/ Manga',
      destinationAddress: 'Cr 21 #25-40 - B/ Chiquinquirá', distanceKm: 3.1,
      sender: _sender, receiver: _receiver, updatedAt: _deliveredDate,
    ),
    PackageModel(
      number: 'DX-141002', weightKg: 12.0, status: PackageStatus.delivered,
      originAddress: 'Av. Pedro de Heredia #31-10 - B/ Pie de la Popa',
      destinationAddress: 'Cl 70 #52-15 - B/ Crespo', distanceKm: 6.4,
      sender: _sender, receiver: _receiver, updatedAt: _deliveredDate,
    ),
  ];

  // Getters: la vista lee las listas, pero no puede modificarlas
  List<PackageModel> get pending => _pending;
  List<PackageModel> get inTransit => _inTransit;
  List<PackageModel> get delivered => _delivered;

  // Resumen para el encabezado de Pendientes
  int get urgentPendingCount => _pending.where((p) => p.isUrgent).length;
  double get pendingDistanceKm => _pending.fold(0.0, (sum, p) => sum + p.distanceKm);
  int get deliveredCount => _delivered.length;
  int get totalCount => _pending.length + _inTransit.length + _delivered.length;

  // ---------- Acciones ----------
  // TO DO: Cargar las guías desde la API (GET /api/packages?status=...) enviando el token JWT.
  // - Agregar _isLoading y _errorMessage, y avisar a la vista (notifyListeners)
  //   al empezar y al terminar para mostrar el indicador de carga o el error.
  // - Las tres listas dejan de ser `final` y empiezan vacías (= []).
}