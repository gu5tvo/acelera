import 'package:flutter/material.dart';

enum LeadTemperature { hot, warm, cold }

enum LeadSource { instagram, whatsapp, site, store }

enum AttendanceStatus { active, scheduled, closed }

enum ChatMessageKind { text, bike, bikes }

enum CreditStatus { pending, approved, rejected }

class CpfSimulation {
  CpfSimulation({
    required this.cpf,
    this.status = CreditStatus.pending,
    this.time = 'agora',
    this.bank,
  });

  final String cpf;
  CreditStatus status;
  final String time;
  final String? bank;
}

extension CreditStatusX on CreditStatus {
  String get label => switch (this) {
    CreditStatus.pending => 'Pendente',
    CreditStatus.approved => 'Aprovado',
    CreditStatus.rejected => 'Reprovado',
  };

  String get hint => switch (this) {
    CreditStatus.pending => 'Aguardando resposta do banco',
    CreditStatus.approved => 'Cliente no radar de atenção',
    CreditStatus.rejected => 'Não aprovado neste CPF',
  };

  Color get color => switch (this) {
    CreditStatus.pending => const Color(0xFF9A6700),
    CreditStatus.approved => const Color(0xFF008069),
    CreditStatus.rejected => const Color(0xFFEF4444),
  };

  Color get background => switch (this) {
    CreditStatus.pending => const Color(0xFFFEF2DE),
    CreditStatus.approved => const Color(0xFFD9FDD3),
    CreditStatus.rejected => const Color(0xFFFDECEC),
  };

  IconData get icon => switch (this) {
    CreditStatus.pending => Icons.schedule_rounded,
    CreditStatus.approved => Icons.check_circle_rounded,
    CreditStatus.rejected => Icons.cancel_rounded,
  };
}

class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.time,
    required this.fromLead,
    this.kind = ChatMessageKind.text,
    this.read = true,
    this.automated = false,
  });

  final String text;
  final String time;
  final bool fromLead;
  final ChatMessageKind kind;
  final bool read;
  final bool automated;
}

class Lead {
  const Lead({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
    required this.interest,
    required this.image,
    required this.source,
    required this.timeAgo,
    required this.temperature,
    required this.tags,
    required this.note,
    required this.avatarColor,
    required this.cpf,
    required this.email,
    required this.birthDate,
    required this.profession,
    required this.address,
    required this.plate,
    required this.bikeYear,
    required this.bikeKm,
  });

  final String id;
  final String name;
  final String phone;
  final String city;
  final String interest;
  final String image;
  final LeadSource source;
  final String timeAgo;
  final LeadTemperature temperature;
  final List<String> tags;
  final String note;
  final Color avatarColor;
  final String cpf;
  final String email;
  final String birthDate;
  final String profession;
  final String address;
  final String plate;
  final String bikeYear;
  final String bikeKm;

  String get firstName => name.split(' ').first;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  String get phoneDigits => phone.replaceAll(RegExp(r'[^0-9]'), '');

  String get phoneSpaced {
    final d = phoneDigits;
    if (d.length == 11) {
      return '${d.substring(0, 2)} ${d.substring(2, 3)} '
          '${d.substring(3, 7)} ${d.substring(7, 11)}';
    }
    if (d.length == 10) {
      return '${d.substring(0, 2)} ${d.substring(2, 6)} '
          '${d.substring(6, 10)}';
    }
    return phone;
  }
}

class Attendance {
  const Attendance({
    required this.lead,
    required this.status,
    required this.elapsed,
    this.schedule,
    this.closedReason,
  });

  final Lead lead;
  final AttendanceStatus status;
  final String elapsed;
  final String? schedule;
  final String? closedReason;
}

class Bike {
  const Bike({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.monthly,
    required this.year,
    required this.km,
    required this.cc,
    required this.image,
    required this.badge,
    required this.colors,
    required this.description,
  });

  final String id;
  final String name;
  final String brand;
  final String category;
  final int price;
  final int monthly;
  final String year;
  final String km;
  final String cc;
  final String image;
  final String badge;
  final List<Color> colors;
  final String description;
}

class AfterSale {
  const AfterSale({
    required this.name,
    required this.bike,
    required this.image,
    required this.purchased,
    required this.followUp,
    required this.avatarColor,
    required this.rating,
  });

  final String name;
  final String bike;
  final String image;
  final String purchased;
  final String followUp;
  final Color avatarColor;
  final int rating;
}

extension LeadSourceX on LeadSource {
  String get label => switch (this) {
    LeadSource.instagram => 'Instagram',
    LeadSource.whatsapp => 'WhatsApp',
    LeadSource.site => 'Site',
    LeadSource.store => 'Loja física',
  };

  IconData get icon => switch (this) {
    LeadSource.instagram => Icons.camera_alt_rounded,
    LeadSource.whatsapp => Icons.chat_bubble_rounded,
    LeadSource.site => Icons.language_rounded,
    LeadSource.store => Icons.storefront_rounded,
  };
}

extension LeadTemperatureX on LeadTemperature {
  String get label => switch (this) {
    LeadTemperature.hot => 'Quente',
    LeadTemperature.warm => 'Morno',
    LeadTemperature.cold => 'Frio',
  };

  Color get color => switch (this) {
    LeadTemperature.hot => const Color(0xFFF04438),
    LeadTemperature.warm => const Color(0xFFF59E0B),
    LeadTemperature.cold => const Color(0xFF3B82F6),
  };

  Color get softColor => switch (this) {
    LeadTemperature.hot => const Color(0xFFFDECEC),
    LeadTemperature.warm => const Color(0xFFFEF2DE),
    LeadTemperature.cold => const Color(0xFFE9F1FF),
  };
}
