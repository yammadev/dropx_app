# DropX App

Aplicación móvil para repartidores del proyecto DropX (gestión de entregas), desarrollada con Flutter.

## Ejecutar en modo de prueba
**Requisitos:** [Flutter](https://docs.flutter.dev/get-started/install) instalado (Dart 3.13.3 o superior) y un emulador o un dispositivo conectado.

```bash
flutter pub get
flutter run
```

Por ahora la aplicación funciona con datos de ejemplo y sin conexión a la API:
el inicio de sesión acepta cualquier correo y contraseña.

## Descripción

Permite al repartidor iniciar sesión, ver sus guías pendientes, recogidas y entregadas,
y consultar el detalle de cada una. Se desarrolla por etapas; el historial de cambios
está en [CHANGELOG.md](CHANGELOG.md).

## Arquitectura (MVVM)
Se utiliza [`provider`](https://pub.dev/packages/provider) para manejar el estado.

- **View** (`lib/views`): interfaz de cada pantalla, sin lógica de negocio.
- **ViewModel** (`lib/viewmodels`): estado y lógica de una pantalla. Extiende `ChangeNotifier`; la vista lo escucha y se redibuja cuando cambia.
- **Model** (`lib/models`): clases de datos.
- **Widgets** (`lib/widgets`): piezas de interfaz reutilizables.
- **Core** (`lib/core`): elementos compartidos, como el tema y los colores.

## Estructura de carpetas

```
dropx_app/
├── android/              # Proyecto nativo Android (generado por Flutter)
├── ios/                  # Proyecto nativo iOS (generado por Flutter)
├── web/                  # Proyecto web (generado por Flutter)
├── assets/
│   └── images/           # Imágenes
│       └── logo.png      # Logo
├── lib/
│   ├── core/
│   │   ├── app_theme.dart            # Colores de la marca y tema global
│   │   └── package_status_style.dart # Texto, icono y color de cada estado de guía
│   ├── models/
│   │   ├── package_model.dart        # Modelo de guía, su estado y contactos
│   │   └── user_model.dart           # Modelo del repartidor (nombre y correo)
│   ├── viewmodels/
│   │   ├── login_viewmodel.dart      # Estado y lógica del login
│   │   ├── packages_viewmodel.dart   # Listas de guías (datos de ejemplo)
│   │   └── user_viewmodel.dart       # Usuario en sesión y cierre de sesión
│   ├── views/
│   │   ├── home_view.dart            # Home con las 4 pestañas
│   │   ├── login_view.dart           # Pantalla de login (UI)
│   │   ├── package_view.dart         # Detalle de una guía
│   │   └── profile_view.dart         # Pestaña de perfil del repartidor
│   ├── widgets/
│   │   ├── contacts_card.dart        # Tarjeta de contactos del detalle
│   │   ├── detail_card.dart          # Tarjeta con título para las secciones del detalle
│   │   ├── package_card.dart         # Tarjeta de una guía
│   │   ├── package_list.dart         # Lista de guías reutilizable
│   │   ├── pending_header.dart       # Encabezado de Pendientes (saludo, resumen y progreso)
│   │   ├── route_card.dart           # Tarjeta de ruta del detalle (con el botón del mapa)
│   │   └── status_band.dart          # Banda de estado del detalle
│   └── main.dart                     # Punto de entrada, MaterialApp y Providers
├── CHANGELOG.md          # Historial de cambios
├── pubspec.yaml          # Dependencias y assets
└── README.md             # Documentación
```

> Este árbol se actualiza en cada paso, a medida que se agregan archivos.