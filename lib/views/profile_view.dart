import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../core/links.dart';
import '../viewmodels/packages_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';
import '../widgets/initial_avatar.dart';
import 'login_view.dart';

// Pestaña de perfil: datos del repartidor y sus opciones.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  // Fila de opción, con el mismo estilo blanco de las tarjetas de guía
  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color, // color del icono y el texto (null = el normal)
    bool showChevron = false, // flecha ">" a la derecha
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        leading: Icon(icon, color: color),
        title: Text(label, style: TextStyle(color: color)),
        trailing: showChevron ? const Icon(Icons.chevron_right) : null,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Escucha el UserViewModel: si cambia el usuario, la pantalla se redibuja
    final user = context.watch<UserViewModel>().user;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      children: [
        // ---------- Avatar, nombre y correo ----------
        Center(
          child: InitialAvatar(name: user.name, radius: 48, fontSize: 40, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        Text(
          user.email,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),

        // ---------- Opción: cambiar contraseña ----------
        // Se hace en la web: abre en el navegador la página de cambio de contraseña de la Suite.
        _buildOption(
          icon: Icons.lock_outline,
          label: 'Cambiar contraseña',
          showChevron: true,
          onTap: () => Links.open(
            context,
            Links.suite('cambiar-contrasena'),
            'No se pudo abrir la página para cambiar la contraseña.',
          ),
        ),
        const SizedBox(height: 10),

        // ---------- Opción: cerrar sesión ----------
        _buildOption(
          icon: Icons.logout,
          label: 'Cerrar sesión',
          color: AppColors.error,
          onTap: () async {
            await context.read<UserViewModel>().logout();
            if (!context.mounted) return; // si la pantalla se cerró, no hacer nada
            context.read<PackagesViewModel>().clear();

            // Vuelve al login y quita todas las pantallas anteriores:
            // con "atrás" no se puede regresar al Home.
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginView()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }
}
