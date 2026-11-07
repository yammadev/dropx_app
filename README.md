# DropX App

Aplicación móvil para repartidores del proyecto DropX (mensajería y logística en Cartagena de Indias), desarrollada con Flutter.

## Capturas

| Emulador | Loading | Login | Perfil |
|---|---|---|---|
| <img src="docs/screenshots/app-emulador.png" width="200"> | <img src="docs/screenshots/app-loading.png" width="200"> | <img src="docs/screenshots/app-login.png" width="200"> | <img src="docs/screenshots/app-perfil.png" width="200"> |
| **Pendientes** | **Recogidos** | **Entregados** | **Paquete** |
| <img src="docs/screenshots/app-pendientes.png" width="200"> | <img src="docs/screenshots/app-recogidos.png" width="200"> | <img src="docs/screenshots/app-entregados.png" width="200"> | <img src="docs/screenshots/app-paquete.png" width="200"> |

## Ejecutar en modo de prueba
**Requisitos:** [Flutter](https://docs.flutter.dev/get-started/install) instalado (Dart 3.13.3 o superior), un emulador o dispositivo conectado y la API de [dropx_web](https://github.com/deavilajuan/dropx_web) en ejecución con los datos de prueba cargados.

```bash
# Copiar .env y generar llave aleatoria
cp .env.example .env

# Instalar requerimientos y encender
flutter pub get
flutter run
```

Para iniciar sesión se usa la cuenta de repartidor `courier@dropx.com` con la clave `SEED_COURIER_PASSWORD` del `.env` de la web.

### Configuración (`.env`)
La configuración está en el archivo `.env` de la raíz (no se sube a GitHub; el modelo es `.env.example`):

| Variable | Descripción | Valor por defecto |
|---|---|---|
| `API_URL` | Dirección de la API | `http://10.0.2.2:5000` |
| `API_TIMEOUT_SECONDS` | Segundos máximos de espera de una respuesta | `15` |

- Emulador de Android: `http://10.0.2.2:5000`.
- Celular real: `http://<IP de la computadora>:5000`, con ambos en la misma red Wi-Fi (la API debe iniciarse con `--host 0.0.0.0`).

Al cambiar el `.env` hay que detener la app y ejecutar `flutter run` de nuevo (un hot reload no lo recarga).

**Recargar las guías:** la app no recibe avisos en tiempo real. Para ver las guías nuevas, se usa el botón de recargar (arriba a la derecha) o deslizar la lista hacia abajo.

**Cambiar el estado de una guía:** en el detalle, los botones de abajo permiten marcarla como recogida o entregada, reportar una novedad o retomar la entrega.

**Si aparece un error de conexión:** el mensaje indica la dirección que usa la app; debe coincidir con la de la API y con el `.env`.

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
│   ├── icon/             # Ícono de la app y logo de la pantalla de carga
│   └── images/           # Imágenes
│       └── logo.png      # Logo
├── lib/
│   ├── core/
│   │   ├── api_config.dart           # Dirección de la API y tiempo de espera
│   │   ├── app_theme.dart            # Colores de la marca y tema global
│   │   └── package_status_style.dart # Texto, icono y color de cada estado de guía
│   ├── models/
│   │   ├── package_model.dart        # Modelo de guía, su estado y contactos
│   │   └── user_model.dart           # Modelo del repartidor (nombre, correo y rol)
│   ├── viewmodels/
│   │   ├── login_viewmodel.dart      # Estado y lógica del login
│   │   ├── packages_viewmodel.dart   # Listas de guías (cargadas desde la API)
│   │   └── user_viewmodel.dart       # Usuario en sesión y cierre de sesión
│   ├── services/
│   │   └── api_service.dart          # Peticiones a la API y token guardado
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
│   │   ├── refresh_button.dart       # Botón para recargar las guías
│   │   ├── route_card.dart           # Tarjeta de ruta del detalle (con el botón del mapa)
│   │   ├── status_actions.dart       # Botones para cambiar el estado de la guía
│   │   └── status_band.dart          # Banda de estado del detalle
│   └── main.dart                     # Punto de entrada, MaterialApp y Providers
├── .env.example          # Modelo del .env (dirección de la API)
├── CHANGELOG.md          # Historial de cambios
├── pubspec.yaml          # Dependencias y assets
└── README.md             # Documentación
```

> Este árbol se actualiza en cada paso, a medida que se agregan archivos.