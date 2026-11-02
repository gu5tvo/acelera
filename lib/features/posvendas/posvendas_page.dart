import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/common.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';

class PosVendasPage extends StatelessWidget {
  const PosVendasPage({super.key});

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final today = MockData.afterSales.take(2).toList(growable: false);
    final upcoming = MockData.afterSales.skip(2).toList(growable: false);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Stack(
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                WhatsAppSliverAppBar(
                  title: 'Pós-vendas',
                  actions: [
                    IconButton(
                      onPressed: () => _toast(context, 'Central de ajuda'),
                      icon: const Icon(
                        Icons.support_agent_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      tooltip: 'Ajuda',
                    ),
                    IconButton(
                      onPressed: () => _toast(context, 'Mais opções · em breve'),
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      tooltip: 'Mais',
                    ),
                  ],
                ),
                const SliverToBoxAdapter(child: _NpsCard()),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                    child: SectionHeader(
                      title: 'Follow-ups de hoje',
                      count: today.length,
                      action: 'Agenda',
                      onAction: () => _toast(context, 'Abrir agenda'),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList.separated(
                    itemCount: today.length,
                    separatorBuilder: (_, _) => const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.border,
                      indent: 82,
                    ),
                    itemBuilder: (context, i) =>
                        _AfterSaleRow(afterSale: today[i], today: true),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 22, 16, 4),
                    child: SectionHeader(title: 'Próximos', count: upcoming.length),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 130 + bottomInset),
                  sliver: SliverList.separated(
                    itemCount: upcoming.length,
                    separatorBuilder: (_, _) => const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.border,
                      indent: 82,
                    ),
                    itemBuilder: (context, i) =>
                        _AfterSaleRow(afterSale: upcoming[i], today: false),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 96 + bottomInset,
          child: AppFab(
            icon: Icons.chat_bubble_rounded,
            onTap: () => _toast(context, 'Novo follow-up · em breve'),
          ),
        ),
      ],
    );
  }
}

class _NpsCard extends StatelessWidget {
  const _NpsCard();

  @override
  Widget build(BuildContext context) {
    const bars = [0.46, 0.62, 0.52, 0.78, 0.68, 1.0];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: RepaintBoundary(
        child: Container(
          height: 186,
          decoration: BoxDecoration(
            gradient: AppColors.heroGradient,
            borderRadius: BorderRadius.circular(26),
            boxShadow: const [
              BoxShadow(
                color: Color(0x330A1224),
                blurRadius: 28,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Stack(
              children: [
                Positioned(
                  right: -50,
                  top: -70,
                  child: Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.04),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'SATISFAÇÃO DOS CLIENTES',
                            style: jk(
                              9,
                              700,
                              color: Colors.white.withValues(alpha: 0.5),
                              letterSpacing: 0.8,
                              height: 1.1,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lime,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.trending_up_rounded,
                                  size: 11,
                                  color: AppColors.ink,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '+8 pts',
                                  style: jk(
                                    9.5,
                                    800,
                                    color: AppColors.ink,
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${MockData.nps}',
                                      style: jk(
                                        40,
                                        800,
                                        color: Colors.white,
                                        height: 0.95,
                                        letterSpacing: -1.6,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        'NPS',
                                        style: jk(
                                          11,
                                          700,
                                          color: Colors.white.withValues(
                                            alpha: 0.5,
                                          ),
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Excelente · acima da média do setor',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: jk(
                                    11,
                                    500,
                                    color: Colors.white.withValues(alpha: 0.66),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 82,
                            height: 58,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                for (var i = 0; i < bars.length; i++)
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: i == bars.length - 1 ? 0 : 5,
                                      ),
                                      child: Container(
                                        height: 58 * bars[i],
                                        decoration: BoxDecoration(
                                          color: i == bars.length - 1
                                              ? AppColors.lime
                                              : Colors.white.withValues(
                                                  alpha: 0.18,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const _NpsDot(),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '5 clientes em acompanhamento',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: jk(
                                10.5,
                                600,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '2 follow-ups hoje',
                            style: jk(10.5, 700, color: AppColors.lime),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NpsDot extends StatelessWidget {
  const _NpsDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: AppColors.lime,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _AfterSaleRow extends StatelessWidget {
  const _AfterSaleRow({required this.afterSale, required this.today});

  final AfterSale afterSale;
  final bool today;

  @override
  Widget build(BuildContext context) {
    final tags = afterSale.name
        .split(RegExp(r'\s+'))
        .map((part) => part[0])
        .take(2)
        .join()
        .toUpperCase();
    return InkWell(
      onTap: () => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Acompanhamento de ${afterSale.name}')),
        ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            InitialsAvatar(
              initials: tags,
              color: afterSale.avatarColor,
              size: 52,
              showOnline: today,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          afterSale.name,
                          style: jk(16, 700, color: AppColors.ink, height: 1.2),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        afterSale.followUp,
                        style: jk(
                          11.5,
                          today ? 700 : 500,
                          color: today
                              ? const Color(0xFF9A6700)
                              : AppColors.inkMuted,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${afterSale.bike} · comprou ${afterSale.purchased}',
                          style: jk(
                            14,
                            500,
                            color: AppColors.inkSoft,
                            height: 1.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          for (var i = 0; i < 5; i++)
                            Icon(
                              Icons.star_rounded,
                              size: 13,
                              color: i < afterSale.rating
                                  ? AppColors.warning
                                  : AppColors.border,
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
