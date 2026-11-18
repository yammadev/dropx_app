# Compilación Android de DropX

## Entorno de referencia

La reparación se verifica con Flutter **3.50.0 stable** y su Dart **3.14.0**.
Usa esa versión de Flutter para reproducir las dependencias de `pubspec.lock`;
no ejecutes `flutter pub upgrade` como parte de la preparación.

- Android SDK Platform **36**, Build Tools **36.0.0** y NDK **28.2.13676358**.
- SDK Platform **35** y CMake **3.22.1**: algunas dependencias también los requieren.
  Gradle puede descargarlos si las licencias están aceptadas y hay acceso a Internet.
- JDK **25.0.4**, incluido en Android Studio JBR, fue el utilizado en Windows.
  AGP requiere al menos JDK 17; los targets de compilación Java/Kotlin son 17.
  Confirma el JDK efectivo con `flutter doctor -v`; no basta con `java -version`.
- Gradle Wrapper **9.3.1**, AGP **9.1.1** y KGP declarado **2.4.0**.
  No hace falta instalar Gradle globalmente: el wrapper descarga su distribución.
- Dispositivo Android **7.0/API 24** o superior para probar el APK.

`compileSdk` y `targetSdk` resuelven a 36 con Flutter 3.50.0; `minSdk` a 24.
Las versiones se toman del SDK Flutter, por lo que cambiar Flutter puede cambiarlas.
La primera compilación necesita Internet y espacio para SDK, Gradle y sus cachés.

## Clonar y configurar

```sh
git clone https://github.com/yammadev/dropx_app.git
cd dropx_app
flutter --version
flutter doctor
flutter doctor --android-licenses
```

Con el PR integrado, clonar `main` incluye los tres archivos del wrapper.
Para revisarlo antes de integrar, clona el fork del PR seleccionando su rama
`fix/flutter-android-build`.

Crea `.env` en la raíz a partir del ejemplo versionado:

```sh
# Bash
cp .env.example .env
```

```powershell
# PowerShell (alternativa al comando anterior)
Copy-Item .env.example .env
```

Configura la URL del backend elegido y un timeout positivo. Para el backend público:

```dotenv
API_URL=https://dropx-web.onrender.com
API_TIMEOUT_SECONDS=15
```

`.env.example` usa una dirección de emulador como ejemplo seguro. `.env` se ignora
en Git, pero se empaqueta **dentro del APK**: solo debe contener configuración
pública. No pongas contraseñas, tokens ni claves del backend en ese archivo.
No es necesario generar una clave JWT para Flutter.

Comprueba la exclusión sin mostrar su contenido:

```sh
git check-ignore -v .env
git ls-files -- .env
```

El segundo comando no debe devolver archivos.

Instala las dependencias y verifica el código desde la raíz:

```sh
flutter pub get
flutter analyze
```

Con Flutter 3.50.0, el análisis de esta reparación encontró 22 observaciones
informativas y ningún error ni warning de Dart. `flutter analyze` devolvió código
1 por esas observaciones (incluyen la deprecación de `flutter/material.dart`).
No se cambian pantallas ni imports de interfaz en este arreglo de compilación;
la migración de UI debe revisarse por separado. No confundas ese resultado con
un análisis sin observaciones.

`android/local.properties` es local y no se versiona. Flutter normalmente lo crea
con las rutas del SDK de Android y Flutter. Si falta o contiene rutas antiguas,
comprueba la instalación con `flutter doctor -v` y ejecuta `flutter pub get`.
Para ejecutar Gradle directamente, ambas propiedades `sdk.dir` y `flutter.sdk`
deben apuntar a instalaciones existentes en esa computadora.

En PowerShell, si Java no está en PATH, configura solo la sesión; ajusta la ruta:

```powershell
$env:JAVA_HOME = 'C:\Program Files\Android\Android Studio\jbr'
.\android\gradlew.bat --version
```

En macOS/Linux, si el permiso de ejecución no está disponible, usa
`sh android/gradlew --version` o restaura el permiso con `chmod +x android/gradlew`.

## Generar e instalar el APK de prueba

```sh
flutter build apk --release
```

Salida: `build/app/outputs/flutter-apk/app-release.apk`.
La configuración actual firma release con la **clave debug** y conserva
`com.example.dropx_app`. Este APK sirve para pruebas internas; la publicación
formal requiere una decisión separada sobre firma e identificador.

Con un dispositivo conectado por USB y depuración USB autorizada:

```sh
flutter devices
adb devices
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

Si hay varios dispositivos, añade `adb -s <serial>`. Si una aplicación previa usa
otro certificado, `-r` no podrá actualizarla: decide cómo conservar sus datos antes
de desinstalarla. Esta guía no ejecuta ni exige una desinstalación automática.

Abre DropX, inicia sesión con una cuenta de pruebas de rol `courier` y verifica
la lista de guías. Los cambios de estado deben probarse únicamente con guías
de prueba autorizadas. No se incluyen credenciales en el repositorio.

## Problemas encontrados y solución

| Problema | Solución aplicada o comprobación |
|---|---|
| Faltaban `gradlew`, `gradlew.bat` y `gradle-wrapper.jar` | Recuperados del proyecto generado por Flutter y versionados; se retiraron sus reglas de exclusión. No se necesita `temp_wrapper` para compilar un clon. |
| Flutter 3.50.0 rechazaba AGP 9.1.0 | Actualización mínima a 9.1.1; se conserva Gradle 9.3.1 y su `gradle-wrapper.properties`. |
| `.env` aparecía en los assets intermedios pero faltaba en el APK | El filtro Android predeterminado `.*` excluía archivos ocultos. `androidResources.ignoreAssetsPattern` conserva las demás exclusiones y permite el asset ya declarado en `pubspec.yaml`. |
| Dependencias transitivas del SDK anterior | El lockfile incorpora `listen 1.0.1`, `meta 1.19.0`, `test_api 0.7.14` y `vector_math 2.4.4`, resueltas con Flutter 3.50.0. |
| Java no encontrado o `JAVA_HOME` inválido | Usar la ruta real de Android Studio JBR y comprobar el JDK con Flutter Doctor. No copiar rutas personales a Git. |
| SDK/NDK/CMake ausentes o licencias pendientes | Instalar los componentes indicados mediante SDK Manager y aceptar las licencias; no cambiar arbitrariamente las versiones Gradle. |
| Falta `.env` o error al cargarlo | Crear el archivo en la raíz antes de compilar. `main.dart` lo carga antes de `runApp`; después de cambiarlo, reconstruir el APK. |
| No conecta con el servidor | Revisar la URL pública y la disponibilidad de la API; `10.0.2.2` solo apunta al host desde el emulador Android. |

Flutter 3.50.0 advierte del soporte futuro de Gradle 9.3.1, AGP 9.1.1 y Kotlin
resuelto 2.4.10. Son advertencias, no se usa ningún flag para omitir validaciones.
También pueden aparecer avisos de acceso nativo de JBR y de XML del SDK por
desfase entre herramientas. No justifican actualizar dependencias durante esta
reparación. La falta de Visual Studio solo afecta a compilar Windows.

## Verificación del artefacto

Además del resultado de Gradle, comprueba que el APK exista, que `apksigner verify`
acepte su firma y que el ZIP contenga `assets/flutter_assets/.env`. Una compilación
exitosa sin ese asset no completa la preparación de DropX. No extraigas ni imprimas
su contenido en registros públicos. El tamaño del APK puede variar entre entornos.

Los resultados ejecutados para esta reparación se registran en la descripción del
Pull Request, distinguiendo la compilación de las pruebas manuales en dispositivo.
