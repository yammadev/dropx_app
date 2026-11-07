import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // SystemUiOverlayStyle
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/package_model.dart';

import '../viewmodels/packages_viewmodel.dart';
import '../widgets/package_list.dart';
import '../widgets/pending_header.dart';
import '../widgets/refresh_button.dart';
import 'profile_view.dart';

// Pantalla principal: 4 pestañas (barra inferior).
// Pendientes no lleva barra superior (su encabezado naranja llega hasta arriba);
// las demás pestañas sí, con el título y una flecha para volver.
// Es StatefulWidget solo para recordar qué pestaña está seleccionada
// (estado puramente visual, por eso no va en un ViewModel).
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0; // 0 = Pendientes, 1 = Recogidos, 2 = Entregados, 3 = Perfil

  // Títulos de la barra superior (Pendientes no la usa, por eso va vacío)
  static const _titles = ['', 'Recogidos', 'Entregados', 'Perfil'];

  // Vuelve a la pestaña Pendientes
  void _goToPending() => setState(() => _currentIndex = 0);

  // Guías de relleno para dibujar el esqueleto mientras carga la primera vez
  static final _placeholders = List.generate(4, (_) => PackageModel.placeholder());

  // Muestra la lista (con el esqueleto animado mientras carga por primera vez) o el error con el botón para reintentar
  Widget _buildTab(
    PackagesViewModel vm, {
    required List<PackageModel> packages,
    required String statusLabel,
    bool showDateHeader = false,
    Widget? header,
  }) {
    if (vm.errorMessage != null) return _buildError(vm);

    final firstLoad = vm.isLoading && vm.totalCount == 0;
    return Skeletonizer(
      enabled: firstLoad,
      ignoreContainers: true, // conserva los colores de las tarjetas y del encabezado
      child: PackageList(
        packages: firstLoad ? _placeholders : packages,
        statusLabel: statusLabel,
        showDateHeader: showDateHeader,
        header: header,
      ),
    );
  }

  Widget _buildError(PackagesViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 12),
            Text(vm.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: vm.loadPackages, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Escucha el ViewModel: si las listas cambian, se redibuja
    final vm = context.watch<PackagesViewModel>();

    return PopScope(
      // Con el botón "atrás" del celular, desde cualquier otra pestaña se vuelve
      // a Pendientes; solo desde Pendientes se cierra la pantalla.
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goToPending();
      },
      // Iconos de la barra de estado en blanco (se ven sobre el encabezado naranja)
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          // ---------- Barra superior (el color sale del tema) ----------
          // En Pendientes no hay barra: el encabezado naranja ocupa ese lugar.
          appBar: _currentIndex == 0
              ? null
              : AppBar(
                  automaticallyImplyLeading: false, // no agregar botón por defecto
                  leadingWidth: 48,
                  titleSpacing: 0,
                  // Flecha para volver a Pendientes
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _goToPending,
                    // Sin efecto de toque ni de hover (sin círculo ni onda alrededor)
                    style: const ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      splashFactory: NoSplash.splashFactory,
                    ),
                  ),
                  title: Text(_titles[_currentIndex]),
                  // Recargar guías (no aplica en el Perfil)
                  actions: [if (_currentIndex != 3) const RefreshButton()],
                ),

          // ---------- Contenido: una pantalla por pestaña ----------
          // IndexedStack mantiene las 4 vivas y muestra solo la seleccionada.
          // Las pestañas de guías muestran el aviso de carga o de error si aplica;
          // el Perfil siempre se puede abrir (para cerrar sesión si el token venció).
          body: IndexedStack(
            index: _currentIndex,
            children: [
              _buildTab(
                vm,
                packages: vm.pending,
                statusLabel: 'pendiente',
                header: const PendingHeader(), // saludo, resumen y progreso
              ),
              _buildTab(vm, packages: vm.inTransit, statusLabel: 'recogida', showDateHeader: true),
              _buildTab(vm, packages: vm.delivered, statusLabel: 'entregada', showDateHeader: true),
              const ProfileView(),
            ],
          ),

          // ---------- Barra inferior (estilo en el tema: core/app_theme.dart) ----------
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) => setState(() => _currentIndex = index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.flag_outlined),
                selectedIcon: Icon(Icons.flag), // relleno cuando está activa
                label: 'Pendientes',
                tooltip: '', // Sin hover al pasar el mouse
              ),
              NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore),
                label: 'Recogidos',
                tooltip: '', // Sin hover al pasar el mouse
              ),
              NavigationDestination(
                icon: Icon(Icons.check_circle_outline),
                selectedIcon: Icon(Icons.check_circle),
                label: 'Entregados',
                tooltip: '', // Sin hover al pasar el mouse
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Perfil',
                tooltip: '', // Sin hover al pasar el mouse
              ),
            ],
          ),
        ),
      ),
    );
  }
}