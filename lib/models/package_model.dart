// Estado de una guía. La pestaña "Recogidos" muestra las guías inTransit.
enum PackageStatus { pending, inTransit, delivered }

// Datos de una guía. Por ahora solo lo que necesita la tarjeta de la lista;
// el detalle (remitente, destinatario, fecha) se agrega en otro paso.
class PackageModel {
  final String number;
  final double weightKg;
  final String originAddress;
  final String destinationAddress;
  final double distanceKm;
  final bool isUrgent;
  final PackageStatus status;

  const PackageModel({
    required this.number,
    required this.weightKg,
    required this.originAddress,
    required this.destinationAddress,
    required this.distanceKm,
    required this.status,
    this.isUrgent = false,
  });
}
