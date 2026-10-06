# DropX App

Aplicación Flutter del proyecto DropX (gestión de entregas para repartidores).

## Descripción

App móvil para repartidores: iniciar sesión, ver los paquetes pendientes,
recogidos y entregados, y consultar el detalle de cada uno. Se desarrolla paso
a paso con la arquitectura **MVVM**, usando
[`provider`](https://pub.dev/packages/provider) para manejar el estado.

## Arquitectura (MVVM)

- **View** (`lib/views`): lo que ve el usuario. Solo interfaz, sin lógica de negocio.
- **ViewModel** (`lib/viewmodels`): estado y lógica de una pantalla. Extiende
  `ChangeNotifier`; la vista lo escucha y se redibuja cuando cambia.
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
│   │   └── app_theme.dart            # Colores de la marca y tema global
│   ├── models/
│   │   └── package_model.dart        # Modelo de guía y su estado
│   ├── viewmodels/
│   │   ├── login_viewmodel.dart      # Estado y lógica del login
│   │   └── packages_viewmodel.dart   # Listas de guías (datos de ejemplo)
│   ├── views/
│   │   ├── home_view.dart            # Home con las 3 pestañas
│   │   └── login_view.dart           # Pantalla de login (UI)
│   ├── widgets/
│   │   ├── package_card.dart         # Tarjeta de una guía
│   │   └── package_list.dart         # Lista de guías reutilizable
│   └── main.dart                     # Punto de entrada, MaterialApp y Providers
├── pubspec.yaml          # Dependencias y assets
└── README.md             # Documentación
```

> Este árbol se actualiza en cada paso, a medida que se agregan archivos.

## ¿Cómo ejecutar?

```bash
flutter pub get
flutter run
```

## Changelog

Todos los cambios importantes de este proyecto se documentan en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/)
y este proyecto sigue el [Versionado Semántico](https://semver.org/lang/es/).

## [Unreleased]

## [0.0.3] - 2026-10-06
### Agregado
- Home con barra inferior de 3 pestañas: Pendientes, Recogidos y Entregados.
- Listas de guías con datos de ejemplo (tarjetas normales y urgentes).
- Modelo `PackageModel` y `PackagesViewModel`; la carga desde la API queda pendiente (TO DO).

### Cambiado
- El login ahora navega al Home.
- Los ViewModels se registran con `MultiProvider` sobre el `MaterialApp`.

## [0.0.2] - 2026-10-05
### Agregado
- Pantalla de login (solo UI) con arquitectura MVVM y `provider`.
- Colores de la marca y tema global (`core/app_theme.dart`).
- Logo como asset.
- Petición de login a la API dejada comentada en `LoginViewModel` para una fase posterior.

## [0.0.1] - 2026-10-05

### Agregado
- Punto de partida del proyecto Flutter.