// Estado de una guía. La pestaña "Recogidos" muestra las guías inTransit
// y también las que tienen una novedad (problem), porque siguen en manos del repartidor.
// Cada estado guarda su nombre en la API: picked_up = en tránsito, issue = problema.
enum PackageStatus {
  pending('pending'),
  inTransit('picked_up'),
  delivered('delivered'),
  problem('issue');

  final String apiValue;
  const PackageStatus(this.apiValue);
}

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
  final int id; // identificador en la API (se usa para cambiar el estado)
  final String number;
  final double weightKg;
  final String originAddress;
  final String destinationAddress;
  final double distanceKm;
  final double? originLat; // ubicación en el mapa (la API la manda vacía si no se eligió)
  final double? originLng;
  final double? destinationLat;
  final double? destinationLng;
  final String? issueReason; // motivo de la novedad (solo si el estado es problem)
  final bool isUrgent;
  final PackageStatus status;
  final ContactModel sender; // quien remite (envía)
  final ContactModel receiver; // quien recibe
  final DateTime updatedAt; // última actualización del estado

  const PackageModel({
    required this.id,
    required this.number,
    required this.weightKg,
    required this.originAddress,
    required this.destinationAddress,
    required this.distanceKm,
    required this.status,
    required this.sender,
    required this.receiver,
    required this.updatedAt,
    this.originLat,
    this.originLng,
    this.destinationLat,
    this.destinationLng,
    this.issueReason,
    this.isUrgent = false,
  });

  // Crea la guía a partir del JSON de la API.
  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
        id: json['id'],
        number: json['number'],
        weightKg: (json['weightKg'] as num).toDouble(),
        originAddress: json['originAddress'],
        destinationAddress: json['destinationAddress'],
        distanceKm: (json['distanceKm'] as num).toDouble(),
        originLat: (json['originLat'] as num?)?.toDouble(),
        originLng: (json['originLng'] as num?)?.toDouble(),
        destinationLat: (json['destinationLat'] as num?)?.toDouble(),
        destinationLng: (json['destinationLng'] as num?)?.toDouble(),
        issueReason: json['issueReason'],
        isUrgent: json['isUrgent'],
        status: PackageStatus.values.firstWhere((s) => s.apiValue == json['status']),
        sender: ContactModel.fromJson(json['sender']),
        receiver: ContactModel.fromJson(json['receiver']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  // Guía de relleno: el esqueleto de carga (skeleton) la usa para dibujar la forma de las tarjetas.
  factory PackageModel.placeholder() => PackageModel(
        id: 0,
        number: 'DX-000000',
        weightKg: 10,
        originAddress: 'Cr 00 # 00-00 - B/ Barrio',
        destinationAddress: 'Cr 00 # 00-00 - B/ Barrio',
        distanceKm: 5,
        status: PackageStatus.pending,
        sender: const ContactModel(name: 'Nombre Apellido', document: 'CC 0', phone: '300 000 0000'),
        receiver: const ContactModel(name: 'Nombre Apellido', document: 'CC 0', phone: '300 000 0000'),
        updatedAt: DateTime.now(),
      );
}
