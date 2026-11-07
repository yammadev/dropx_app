# Changelog

Todos los cambios importantes de este proyecto se documentan en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/)
y este proyecto sigue el [Versionado Semántico](https://semver.org/lang/es/).

## [Unreleased]

## [1.2.2] - 2026-11-07
### Cambiado
- Tamaño de las imágenes del README. 

## [1.2.1] - 2026-11-07
### Cambiado
- Tamaño de las imágenes del README. 

## [1.2.0] - 2026-11-07
### Agregado
- Botón de recargar las guías (arriba a la derecha) y recarga al deslizar la lista hacia abajo, porque la app no recibe avisos en tiempo real.
- Cambio de estado desde el detalle de la guía (`PATCH /api/packages/<id>/status`): marcar como recogida, entregada, reportar novedad o retomar la entrega, con confirmación. Las guías entregadas ya no se pueden cambiar.
- Pantalla de carga al abrir la app (logo de DropX), generada con `flutter_native_splash`.
- Animación de carga tipo esqueleto (skeleton) en las listas de guías, con `skeletonizer`.
- `id` en `PackageModel` y `PackageStatus.apiValue` (nombre del estado en la API).

## [1.1.0] - 2026-11-07
### Agregado
- Conexión con la API (`dropx_web`): `ApiConfig` y `ApiService` (login y guías asignadas, con mensajes de error en español).
- Inicio de sesión real (`POST /api/auth/login`): solo entran cuentas de repartidor; el token JWT se guarda en el teléfono con `shared_preferences`.
- Guías asignadas (`GET /api/packages`): las pestañas Pendientes, Recogidos y Entregados muestran las guías del repartidor, con indicador de carga y botón para reintentar si falla.
- Archivo `.env` (modelo en `.env.example`) con `API_URL` y `API_TIMEOUT_SECONDS`, leído con `flutter_dotenv`.
- Ícono de la app (logo de DropX), generado con `flutter_launcher_icons`.
- `fromJson` en `UserModel`, `PackageModel` y `ContactModel`, con la equivalencia de estados (`picked_up` = en tránsito, `issue` = problema).
- Permiso de internet en Android.
- Guía para probar la app paso a paso en el `README.md`.

### Cambiado
- El nombre de la app en el celular pasa de `dropx_app` a `DropX` (Android e iOS).
- El perfil muestra el nombre y el correo del repartidor que inició sesión.
- Cerrar sesión borra el token y vacía las guías.
- Las guías de ejemplo se reemplazan por las de la API.

### Eliminado
- Datos de ejemplo de las guías.

## [0.0.8] - 2026-11-05
### Cambiado
- La app queda limitada a Cartagena de Indias: la descripción y los datos de ejemplo (barrios y direcciones) corresponden a la ciudad.

## [0.0.7] - 2026-11-05
### Cambiado
- El changelog pasa del `README.md` a este archivo (`CHANGELOG.md`).
- El `README.md` se reduce: primero las instrucciones para ejecutar la app y después la descripción, la arquitectura y la estructura de carpetas.

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
