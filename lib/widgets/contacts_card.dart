import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/package_model.dart';
import 'detail_card.dart';

// Tarjeta CONTACTOS del detalle: quien remite y quien recibe.
class ContactsCard extends StatelessWidget {
  final ContactModel sender;
  final ContactModel receiver;

  const ContactsCard({super.key, required this.sender, required this.receiver});

  // Línea pequeña con icono (cédula o teléfono)
  Widget _buildContactLine(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  // Un contacto: inicial en círculo, etiqueta (REMITE / RECIBE), nombre, cédula y teléfono
  Widget _buildContact(String role, ContactModel contact) {
    final initial = contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.pillBackground,
          child: Text(
            initial,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  role,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                contact.name,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              _buildContactLine(Icons.badge_outlined, contact.document),
              _buildContactLine(Icons.phone_outlined, contact.phone),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'CONTACTOS',
      child: Column(
        children: [
          _buildContact('REMITE', sender),
          const Divider(height: 24),
          _buildContact('RECIBE', receiver),
        ],
      ),
    );
  }
}
