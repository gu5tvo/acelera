import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/common.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import 'lead_detail_page.dart';

class LeadsPage extends StatefulWidget {
  const LeadsPage({super.key});

  @override
  State<LeadsPage> createState() => _LeadsPageState();
}

class _LeadsPageState extends State<LeadsPage> {
  static const _filters = ['Todos', 'Quentes', 'Financiamento', 'Troca'];
  int _filter = 0;
  String _query = '';

  List<Lead> get _leads {
    final query = _query.trim().toLowerCase();
    return MockData.leads
        .where((lead) {
          final matchesFilter = switch (_filter) {
            1 => lead.temperature == LeadTemperature.hot,
            2 => lead.tags.contains('Financiamento'),
            3 => lead.tags.contains('Troca'),
            _ => true,
          };
          final matchesQuery =
              query.isEmpty ||
              lead.name.toLowerCase().contains(query) ||
              lead.interest.toLowerCase().contains(query) ||
              lead.phone.contains(query);
          return matchesFilter && matchesQuery;
        })
        .toList(growable: false);
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final leads = _leads;
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
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: AppColors.primaryDeep,
                    surfaceTintColor: Colors.transparent,
                    elevation: 0,
                    systemOverlayStyle: SystemUiOverlayStyle.light,
                    titleSpacing: 20,
                    title: Text(
                      'Acelera',
                      style: jk(19.5, 700, color: Colors.white),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () => _toast('Novas conversas · em breve'),
                        icon: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        tooltip: 'Nova conversa',
                      ),
                      IconButton(
                        onPressed: () => _toast('Notificações · em breve'),
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        tooltip: 'Notificações',
                      ),
                      IconButton(
                        onPressed: () => _toast('Mais opções · em breve'),
                        icon: const Icon(
                          Icons.more_vert_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        tooltip: 'Mais',
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(child: _HeroCard()),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: AppSearchField(
                        hint: 'Buscar nome, moto ou telefone',
                        onChanged: (value) => setState(() => _query = value),
                        onFilter: () {},
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _filters.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, i) => AppFilterChip(
                            label: _filters[i],
                            selected: _filter == i,
                            onTap: () => setState(() => _filter = i),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                      child: SectionHeader(
                        title: 'Novos contatos',
                        count: leads.length,
                      ),
                    ),
                  ),
                  if (leads.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyLeads(),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 130 + bottomInset),
                      sliver: SliverList.separated(
                        itemCount: leads.length,
                        separatorBuilder: (_, _) => const Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.border,
                          indent: 82,
                        ),
                        itemBuilder: (context, i) =>
                            _LeadChatRow(lead: leads[i]),
                      ),
                    ),
                ],
              ),
            ),
          ),
        Positioned(
          right: 20,
          bottom: 96 + bottomInset,
          child: _NewChatFab(onTap: () => _toast('Novo contato · em breve')),
        ),
      ],
    );
  }
}

class _NewChatFab extends StatelessWidget {
  const _NewChatFab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.lime,
      shape: const CircleBorder(),
      elevation: 6,
      shadowColor: const Color(0x3325D366),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 56,
          height: 56,
          child: Icon(
            Icons.chat_bubble_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  void _openRadar(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const _RadarPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final approved = MockData.leads.where(MockData.hasApproved).toList();
    final pending = MockData.leads.where(MockData.hasPending).length;
    final rejected = MockData.leads.where(MockData.hasRejected).length;
    final sentence = switch (approved.length) {
      0 => 'Nenhuma aprovação ainda. As novas caem aqui na hora.',
      1 => '${approved.first.firstName} aguardando seu contato.',
      _ =>
        '${approved.take(approved.length - 1).map((l) => l.firstName).join(', ')} '
            'e ${approved.last.firstName} aguardam seu contato.',
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: RepaintBoundary(
        child: GestureDetector(
          onTap: () => _openRadar(context),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Positioned(
                    right: -46,
                    top: -70,
                    child: Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.07),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 18,
                    top: 18,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.credit_score_rounded,
                        color: AppColors.primaryDeep,
                        size: 22,
                      ),
                    ),
                  ),
                  Positioned(
                    left: -30,
                    bottom: -60,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                          width: 22,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'RADAR · AGORA',
                                style: jk(
                                  9.5,
                                  700,
                                  color: Colors.white,
                                  letterSpacing: 0.8,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${approved.length} aprovações de crédito',
                          style: jk(
                            24,
                            800,
                            color: Colors.white,
                            height: 1.08,
                            letterSpacing: -0.7,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          sentence,
                          style: jk(
                            12,
                            500,
                            color: Colors.white.withValues(alpha: 0.72),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _HeroStat(
                                value: '${approved.length}',
                                label: 'aprovados',
                                color: AppColors.success,
                              ),
                            ),
                            _divider(),
                            Expanded(
                              child: _HeroStat(
                                value: '$pending',
                                label: 'pendentes',
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            _divider(),
                            Expanded(
                              child: _HeroStat(
                                value: '$rejected',
                                label: 'reprovados',
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
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
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 26,
      margin: const EdgeInsets.symmetric(horizontal: 9),
      color: Colors.white.withValues(alpha: 0.16),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.value,
    required this.label,
    this.color = Colors.white,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: jk(
            15,
            800,
            color: color,
            height: 1.1,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: jk(
            9.5,
            500,
            color: Colors.white.withValues(alpha: 0.6),
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class _LeadChatRow extends StatelessWidget {
  const _LeadChatRow({required this.lead});

  final Lead lead;

  void _open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => LeadDetailPage(lead: lead)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hot = lead.temperature == LeadTemperature.hot;
    return InkWell(
      onTap: () => _open(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            InitialsAvatar(
              initials: lead.initials,
              color: lead.avatarColor,
              size: 52,
              showOnline: hot,
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
                          lead.name,
                          style: jk(16, 700, color: AppColors.ink, height: 1.2),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        lead.timeAgo,
                        style: jk(
                          11.5,
                          hot ? 700 : 500,
                          color: hot
                              ? AppColors.primaryDeep
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
                          '${lead.source.label} · ${lead.interest}',
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
                      if (hot) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: AppColors.lime,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_fire_department_rounded,
                            color: Colors.white,
                            size: 13,
                          ),
                        ),
                      ],
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

class _EmptyLeads extends StatelessWidget {
  const _EmptyLeads();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 120),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              color: AppColors.surfaceAlt,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              color: AppColors.inkMuted,
              size: 30,
            ),
          ),
          const SizedBox(height: 14),
          Text('Nenhum contato por aqui', style: AppText.h3),
          const SizedBox(height: 4),
          Text(
            'Ajuste os filtros ou tente outra busca.',
            style: AppText.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _RadarPage extends StatelessWidget {
  const _RadarPage();

  @override
  Widget build(BuildContext context) {
    final leads = MockData.leads.where(MockData.hasApproved).toList();
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          WhatsAppSliverAppBar(title: 'Radar · crédito aprovado'),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                '${leads.length} clientes aprovados e aguardando seu contato. '
                'São os que mais precisam de atenção agora.',
                style: AppText.body.copyWith(height: 1.5),
              ),
            ),
          ),
          if (leads.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyLeads(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 24),
              sliver: SliverList.separated(
                itemCount: leads.length,
                separatorBuilder: (_, _) => const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.border,
                  indent: 82,
                ),
                itemBuilder: (context, i) => _LeadChatRow(lead: leads[i]),
              ),
            ),
        ],
      ),
    );
  }
}
