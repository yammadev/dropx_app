// Estado de una guía. La pestaña "Recogidos" muestra las guías inTransit
// y también las que tienen una novedad (problem), porque siguen en manos del repartidor.
enum PackageStatus { pending, inTransit, delivered, problem }

// Persona que envía o recibe una guía (remitente o destinatario).
class ContactModel {
  final String name;
  final String document; // ej: "CC 1.100.000.000"
  final String phone;

  const ContactModel({
    required this.name,
    required this.document,
    required this.phone,
  });
}

// Datos de una guía: lo que muestra la tarjeta de la lista y la pantalla de detalle.
class PackageModel {
  final String number;
  final double weightKg;
  final String originAddress;
  final String destinationAddress;
  final double distanceKm;
  final bool isUrgent;
  final PackageStatus status;
  final ContactModel sender; // quien remite (envía)
  final ContactModel receiver; // quien recibe
  final DateTime updatedAt; // última actualización del estado

  const PackageModel({
    required this.number,
    required this.weightKg,
    required this.originAddress,
    required this.destinationAddress,
    required this.distanceKm,
    required this.status,
    required this.sender,
    required this.receiver,
    required this.updatedAt,
    this.isUrgent = false,
  });
}
