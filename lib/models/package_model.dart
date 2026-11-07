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

  // Crea el contacto a partir del JSON de la API (el documento puede venir vacío)
  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        name: json['name'],
        document: json['document'] ?? '',
        phone: json['phone'],
      );
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

  // Crea la guía a partir del JSON de la API.
  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
        number: json['number'],
        weightKg: (json['weightKg'] as num).toDouble(),
        originAddress: json['originAddress'],
        destinationAddress: json['destinationAddress'],
        distanceKm: (json['distanceKm'] as num).toDouble(),
        isUrgent: json['isUrgent'],
        status: _statusFromApi(json['status']),
        sender: ContactModel.fromJson(json['sender']),
        receiver: ContactModel.fromJson(json['receiver']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  // Estados de la API -> estados de la app:
  // pending = pendiente, picked_up = en tránsito, delivered = entregada, issue = problema
  static PackageStatus _statusFromApi(String status) => switch (status) {
        'picked_up' => PackageStatus.inTransit,
        'delivered' => PackageStatus.delivered,
        'issue' => PackageStatus.problem,
        _ => PackageStatus.pending,
      };
}
