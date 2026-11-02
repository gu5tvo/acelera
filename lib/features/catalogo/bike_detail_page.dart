import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/bike_image.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';

class BikeDetailPage extends StatefulWidget {
  const BikeDetailPage({super.key, required this.bike, required this.heroTag});

  final Bike bike;
  final String heroTag;

  @override
  State<BikeDetailPage> createState() => _BikeDetailPageState();
}

class _BikeDetailPageState extends State<BikeDetailPage> {
  bool _favorite = false;
  int _color = 0;

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final bike = widget.bike;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 336,
              backgroundColor: AppColors.primaryDeep,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              leadingWidth: 68,
              leading: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: _GlassButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              actions: [
                Center(
                  child: _GlassButton(
                    icon: _favorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    iconColor: _favorite ? AppColors.lime : Colors.white,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _favorite = !_favorite);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Center(
                    child: _GlassButton(
                      icon: Icons.ios_share_rounded,
                      onTap: () => _toast('Compartilhar ${bike.name}'),
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: widget.heroTag,
                      child: BikeImage(
                        asset: bike.image,
                        fit: BoxFit.cover,
                        cacheWidth: 1000,
                        alignment: const Alignment(0, -0.15),
                      ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x330A1224),
                            Color(0x000A1224),
                            Color(0x000A1224),
                            Color(0x660A1224),
                          ],
                          stops: [0, 0.25, 0.7, 1],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 42,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.photo_camera_rounded,
                              size: 13,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${bike.category} · ${bike.year}',
                              style: jk(
                                10.5,
                                600,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 28,
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(28),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(color: AppColors.background),
                padding: EdgeInsets.fromLTRB(20, 22, 20, 36 + bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppTag(
                          label: bike.category,
                          color: AppColors.primaryDeep,
                          background: AppColors.primarySoft,
                        ),
                        const SizedBox(width: 6),
                        AppTag(
                          label: bike.badge,
                          color: AppColors.ink,
                          background: AppColors.lime,
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.star_rounded,
                          size: 15,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 3),
                        Text('4.9', style: AppText.bodyStrong),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      bike.name,
                      style: AppText.h1,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${bike.brand} · ${bike.year} · ${bike.km}',
                      style: AppText.body,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(brl(bike.price), style: AppText.money),
                        const SizedBox(width: 7),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text('à vista', style: AppText.caption),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _FinanceCard(bike: bike),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: _Spec(
                            icon: Icons.speed_rounded,
                            value: bike.cc,
                            label: 'Cilindrada',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _Spec(
                            icon: Icons.event_rounded,
                            value: bike.year,
                            label: 'Ano',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _Spec(
                            icon: Icons.route_rounded,
                            value: bike.km,
                            label: 'Rodagem',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Cores disponíveis', style: AppText.h2),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        for (var i = 0; i < bike.colors.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () => setState(() => _color = i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: 38,
                                height: 38,
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _color == i
                                        ? AppColors.ink
                                        : AppColors.border,
                                    width: 2,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: bike.colors[i],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Sobre a moto', style: AppText.h2),
                    const SizedBox(height: 8),
                    Text(
                      bike.description,
                      style: AppText.body.copyWith(height: 1.55),
                    ),
                    const SizedBox(height: 22),
                    Text('Incluso na compra', style: AppText.h2),
                    const SizedBox(height: 10),
                    const Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        AppTag(
                          label: 'Garantia de 3 meses',
                          icon: Icons.verified_rounded,
                          color: AppColors.success,
                          background: AppColors.successSoft,
                        ),
                        AppTag(
                          label: 'Revisão grátis',
                          icon: Icons.build_rounded,
                          color: AppColors.primaryDeep,
                          background: AppColors.primarySoft,
                        ),
                        AppTag(
                          label: 'Manual e chave reserva',
                          icon: Icons.key_rounded,
                          color: AppColors.violet,
                          background: AppColors.violetSoft,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border)),
            boxShadow: [
              BoxShadow(
                color: Color(0x140A1224),
                blurRadius: 24,
                offset: Offset(0, -8),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  AppIconButton(
                    icon: Icons.chat_bubble_rounded,
                    size: 50,
                    onPressed: () => _toast('Enviar para um cliente'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      label: 'Compartilhar com cliente',
                      icon: Icons.ios_share_rounded,
                      variant: AppButtonVariant.lime,
                      onPressed: () => _toast('${bike.name} compartilhada'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FinanceCard extends StatelessWidget {
  const _FinanceCard({required this.bike});

  final Bike bike;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: AppColors.limeGradient,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FINANCIAMENTO',
                  style: jk(
                    9,
                    800,
                    color: AppColors.ink.withValues(alpha: 0.55),
                    letterSpacing: 0.8,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      brl(bike.monthly),
                      style: jk(23, 800, height: 1, letterSpacing: -0.8),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        '/mês',
                        style: jk(
                          11,
                          700,
                          color: AppColors.ink.withValues(alpha: 0.62),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  'Entrada de ${brl((bike.price * 0.1).round())} · 48x',
                  style: jk(
                    10.5,
                    600,
                    color: AppColors.ink.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.ink,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              size: 19,
              color: AppColors.lime,
            ),
          ),
        ],
      ),
    );
  }
}

class _Spec extends StatelessWidget {
  const _Spec({required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 17, color: AppColors.inkSoft),
          const SizedBox(height: 6),
          Text(
            value,
            style: jk(12.5, 800, height: 1.1, letterSpacing: -0.2),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(label, style: AppText.caption, maxLines: 1),
        ],
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({
    required this.icon,
    this.onTap,
    this.iconColor = Colors.white,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ink.withValues(alpha: 0.32),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: iconColor, size: 20),
        ),
      ),
    );
  }
}
