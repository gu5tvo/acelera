import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF0F2F5);

  static const ink = Color(0xFF111B21);
  static const inkSoft = Color(0xFF667781);
  static const inkMuted = Color(0xFF8696A0);
  static const border = Color(0xFFE9EDEF);

  static const primary = Color(0xFF00A884);
  static const primaryDeep = Color(0xFF008069);
  static const primarySoft = Color(0xFFDCF7E8);
  static const lime = Color(0xFF25D366);
  static const limeDeep = Color(0xFF128C7E);

  static const success = Color(0xFF25D366);
  static const successSoft = Color(0xFFD9FDD3);
  static const warning = Color(0xFFF59E0B);
  static const warningSoft = Color(0xFFFEF2DE);
  static const danger = Color(0xFFEF4444);
  static const dangerSoft = Color(0xFFFDECEC);
  static const violet = Color(0xFF7C5CFF);
  static const violetSoft = Color(0xFFEFEBFF);

  static const navy = Color(0xFF0B132B);
  static const navySoft = Color(0xFF16203D);

  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00A884), Color(0xFF008069)],
  );

  static const inkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B132B), Color(0xFF1B2A52)],
  );

  static const limeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF25D366), Color(0xFF1FB856)],
  );

  static const cardShadow = <BoxShadow>[];

  static const floatShadow = [
    BoxShadow(color: Color(0x2E0A1224), blurRadius: 28, offset: Offset(0, 14)),
  ];
}

abstract final class ChatColors {
  static const header = Color(0xFF008069);
  static const headerDeep = Color(0xFF075E54);
  static const wallpaper = Color(0xFFEFEAE2);
  static const bubbleIn = Color(0xFFFFFFFF);
  static const bubbleOut = Color(0xFFD9FDD3);
  static const text = Color(0xFF111B21);
  static const meta = Color(0xFF667781);
  static const tickRead = Color(0xFF53BDEB);
  static const system = Color(0xFFFFF3C2);
  static const systemText = Color(0xFF54656F);
  static const inputBar = Color(0xFFF0F2F5);
  static const accent = Color(0xFF00A884);
  static const hint = Color(0xFF8696A0);
  static const doodle = Color(0x124A5D52);
}
