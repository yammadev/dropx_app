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

## [0.0.6] - 2026-10-06
### Agregado
- `PackageStatusStyle`: texto, icono y color de cada estado de guía en un solo lugar.
- Widgets del detalle: `StatusBand`, `RouteCard`, `ContactsCard` y `DetailCard`.
- Las tarjetas de las listas muestran el estado de la guía (cajita de color arriba a la derecha), para distinguir sobre todo las que tienen novedad.

### Cambiado
- El formato del número de guía pasa de `DX152216` a `DX-152216` (datos de ejemplo y comentarios).
- La pantalla de detalle se divide en widgets más pequeños; no cambia cómo se ve.

## [0.0.5] - 2026-10-06
### Agregado
- Detalle de la guía (sólo UI): encabezado naranja con el número (y la cajita roja "Urgente" si aplica), banda de estado a todo el ancho con su color y la fecha de actualización; ruta con origen, destino, peso y distancia; y contactos de quien remite y quien recibe.
- Botón "Ver ruta en el mapa" en la tarjeta de ruta (sólo UI, sin función todavía).
- Cuarto estado de guía, "Con novedad" (`PackageStatus.problem`), con una guía de ejemplo que se muestra en la pestaña Recogidos.
- `ContactModel` y los campos `sender`, `receiver` y `updatedAt` en `PackageModel` (datos de ejemplo).
- Colores de estado `info` (recogido), `success` (entregado) y `problem` (con novedad) en `AppColors`.

### Cambiado
- Al tocar una tarjeta de la lista se abre el detalle de la guía.
- Los datos de ejemplo de las guías dejan de ser constantes (la fecha no puede serlo).
- En el detalle, la tarjeta de ruta se ve igual para todas las guías; la urgencia solo se indica en el encabezado.
- El mapa de la ruta queda pendiente para una fase posterior (el botón aún no hace nada).

## [0.0.4] - 2026-10-06
### Agregado
- UI mejorada.
- Pestaña de perfil del repartidor (nombre, correo, cambiar contraseña y cerrar sesión).
- Modelo `UserModel` y `UserViewModel` (usuario de ejemplo).
- Cambiar contraseña y cierre de sesión (sólo UI). 
- Encabezado de Pendientes, saludo según la hora, mensaje con el contador, cajitas de urgentes y km en total, y tarjeta con el progreso general. El mensaje y el progreso son generales, no solo del día.

### Cambiado
- Barra superior naranja (color de la marca) con título e iconos blancos.
- La barra inferior pasa de 3 a 4 pestañas y usa el estilo de Material: icono relleno blanco sobre una píldora naranja en la pestaña activa.
- Fondo gris tenue en toda la app; las tarjetas van en blanco encima.
- Tarjetas de guía compactas al estilo Material: número de guía, ruta con iconos de origen y destino, y cajitas con icono para peso y distancia; borde suave.
- Las guías urgentes se muestran con fondo rosa claro y borde rojo y una cajita "Urgente".
- Login: campos blancos con esquinas redondeadas e iconos, mensaje de error en cajita rosa.
- Pendientes ya no lleva barra superior, el encabezado naranja llega hasta arriba. Las demás pestañas conservan su barra con título y flecha.
- Los números de guía usan el prefijo `DX` (ej: `DX152216`).
- Recogidos y Entregados muestran un mensaje con el contador (ej: "Tienes 3 guías recogidas").

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