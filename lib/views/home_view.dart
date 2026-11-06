import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // SystemUiOverlayStyle
import 'package:provider/provider.dart';

import '../viewmodels/packages_viewmodel.dart';
import '../widgets/package_list.dart';
import '../widgets/pending_header.dart';
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
                ),

          // ---------- Contenido: una pantalla por pestaña ----------
          // IndexedStack mantiene las 4 vivas y muestra solo la seleccionada
          body: IndexedStack(
            index: _currentIndex,
            children: [
              PackageList(
                packages: vm.pending,
                statusLabel: 'pendiente',
                header: const PendingHeader(), // saludo, resumen y progreso
              ),
              PackageList(packages: vm.inTransit, statusLabel: 'recogida', showDateHeader: true),
              PackageList(packages: vm.delivered, statusLabel: 'entregada', showDateHeader: true),
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