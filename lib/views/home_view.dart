import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../viewmodels/packages_viewmodel.dart';
import '../widgets/package_list.dart';

// Pantalla principal: barra superior + 3 pestañas (barra inferior).
// Es StatefulWidget solo para recordar qué pestaña está seleccionada
// (estado puramente visual, por eso no va en un ViewModel).
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0; // 0 = Pendientes, 1 = Recogidos, 2 = Entregados

  static const _titles = ['Pendientes', 'Recogidos', 'Entregados'];

  // Vuelve a la pestaña Pendientes
  void _goToPending() => setState(() => _currentIndex = 0);

  @override
  Widget build(BuildContext context) {
    // Escucha el ViewModel: si las listas cambian, se redibuja
    final vm = context.watch<PackagesViewModel>();

    return PopScope(
      // Con el botón "atrás" del celular, desde Recogidos/Entregados se vuelve
      // a Pendientes; solo desde Pendientes se cierra la pantalla.
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goToPending();
      },
      child: Scaffold(
        // ---------- Barra superior ----------
        appBar: AppBar(
          leadingWidth: 48,
          titleSpacing: 0,
          scrolledUnderElevation: 0, // evita que cambie de color al hacer scroll
          leading: _currentIndex == 0
              ? IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    // TO DO: Abrir el menú lateral del usuario
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goToPending,
                ),
          title: Text(_titles[_currentIndex]),
        ),

        // ---------- Contenido: una lista por pestaña ----------
        // IndexedStack mantiene las 3 listas vivas y muestra solo la seleccionada
        body: IndexedStack(
          index: _currentIndex,
          children: [
            PackageList(packages: vm.pending),
            PackageList(packages: vm.inTransit, showDateHeader: true),
            PackageList(packages: vm.delivered, showDateHeader: true),
          ],
        ),

        // ---------- Barra inferior ----------
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          elevation: 0,
          indicatorColor: AppColors.pillBackground,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.flag_outlined),
              selectedIcon: Icon(Icons.flag_outlined, color: AppColors.primary),
              label: 'Pendientes',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore_outlined, color: AppColors.primary),
              label: 'Recogidos',
            ),
            NavigationDestination(
              icon: Icon(Icons.check_circle_outline),
              selectedIcon: Icon(Icons.check_circle_outline, color: AppColors.primary),
              label: 'Entregados',
            ),
          ],
        ),
      ),
    );
  }
}
