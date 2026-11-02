import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../atendimentos/atendimentos_page.dart';
import '../catalogo/catalogo_page.dart';
import '../leads/leads_page.dart';
import '../posvendas/posvendas_page.dart';
import 'app_nav_bar.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _pages = <Widget>[
    LeadsPage(),
    AtendimentosPage(),
    CatalogoPage(),
    PosVendasPage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      for (final bike in MockData.bikes) {
        precacheImage(ResizeImage(AssetImage(bike.image), width: 520), context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            IndexedStack(index: _index, children: _pages),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: AppNavBar(
                      index: _index,
                      onTap: (i) => setState(() => _index = i),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
