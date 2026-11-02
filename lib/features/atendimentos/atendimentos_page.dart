import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/common.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../leads/lead_detail_page.dart';

class AtendimentosPage extends StatefulWidget {
  const AtendimentosPage({super.key});

  @override
  State<AtendimentosPage> createState() => _AtendimentosPageState();
}

class _AtendimentosPageState extends State<AtendimentosPage> {
  AttendanceStatus _segment = AttendanceStatus.active;
  int _credit = 0;
  String _query = '';

  List<Attendance> get _items {
    final q = _query.trim().toLowerCase();
    return MockData.attendances.where((a) {
      if (a.status != _segment) return false;
      final okCredit = switch (_credit) {
        1 => MockData.hasApproved(a.lead),
        2 => MockData.hasRejected(a.lead),
        3 => MockData.hasPending(a.lead),
        _ => true,
      };
      if (!okCredit) return false;
      if (q.isEmpty) return true;
      return a.lead.name.toLowerCase().contains(q) ||
          a.lead.interest.toLowerCase().contains(q) ||
          a.lead.phone.contains(q);
    }).toList();
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
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
                  title: 'Atendimentos',
                  bottom: _StatusTabs(
                    value: _segment,
                    onChanged: (value) => setState(() => _segment = value),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () => _toast('Ordenar atendimentos'),
                      icon: const Icon(
                        Icons.sort_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      tooltip: 'Ordenar',
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    child: AppSearchField(
                      hint: 'Buscar cliente ou moto',
                      onChanged: (value) => setState(() => _query = value),
                      onFilter: () {},
                      showFilter: false,
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
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: 4,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (context, i) => AppFilterChip(
                          label: [
                            'Todos',
                            'Aprovados',
                            'Reprovados',
                            'Pendentes',
                          ][i],
                          icon:
                              [
                                null,
                                Icons.check_circle_rounded,
                                Icons.cancel_rounded,
                                Icons.schedule_rounded,
                              ][i],
                          selected: _credit == i,
                          onTap: () => setState(() => _credit = i),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
                    child: SectionHeader(
                      title: switch (_segment) {
                        AttendanceStatus.active => 'Em atendimento',
                        AttendanceStatus.scheduled => 'Agendados',
                        AttendanceStatus.closed => 'Encerrados',
                      },
                      count: items.length,
                    ),
                  ),
                ),
                if (items.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyAttendances(),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 130 + bottomInset),
                    sliver: SliverList.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.border,
                        indent: 82,
                      ),
                      itemBuilder: (context, i) =>
                          _AttendanceRow(attendance: items[i]),
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
            icon: Icons.forum_rounded,
            onTap: () => _toast('Todos os atendimentos · em breve'),
          ),
        ),
      ],
    );
  }
}

class _StatusTabs extends StatelessWidget implements PreferredSizeWidget {
  const _StatusTabs({required this.value, required this.onChanged});

  final AttendanceStatus value;
  final ValueChanged<AttendanceStatus> onChanged;

  @override
  Size get preferredSize => const Size.fromHeight(48);

  int _countOf(AttendanceStatus status) =>
      MockData.attendances.where((a) => a.status == status).length;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        AttendanceStatus.active,
        'Ativos',
        _countOf(AttendanceStatus.active),
        true,
      ),
      (
        AttendanceStatus.scheduled,
        'Agendados',
        _countOf(AttendanceStatus.scheduled),
        true,
      ),
      (AttendanceStatus.closed, 'Encerrados', _countOf(AttendanceStatus.closed), false),
    ];
    return Container(
      color: AppColors.primaryDeep,
      child: Row(
        children: [
          for (final (status, label, count, showBadge) in tabs)
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onChanged(status),
                  child: SizedBox(
                    height: 48,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                label,
                                style: jk(
                                  13.5,
                                  value == status ? 700 : 600,
                                  color: value == status
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.74),
                                ),
                              ),
                              if (showBadge && count > 0) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: value == status
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.24),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    '$count',
                                    style: jk(
                                      10.5,
                                      800,
                                      color: value == status
                                          ? AppColors.primaryDeep
                                          : Colors.white,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          height: 3,
                          color: value == status
                              ? Colors.white
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyAttendances extends StatelessWidget {
  const _EmptyAttendances();

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
          Text('Nenhum atendimento por aqui', style: AppText.h3),
          const SizedBox(height: 4),
          Text(
            'Ajuste os filtros ou a busca.',
            style: AppText.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AttendanceRow extends StatelessWidget {
  const _AttendanceRow({required this.attendance});

  final Attendance attendance;

  void _open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LeadDetailPage(
          lead: attendance.lead,
          attendanceStatus: attendance.status,
          schedule: attendance.schedule,
          closedReason: attendance.closedReason,
          elapsed: attendance.elapsed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lead = attendance.lead;
    final hot = lead.temperature == LeadTemperature.hot;
    final (snippet, shortLabel, labelColor, labelWeight, avatarColor, online) =
        switch (attendance.status) {
          AttendanceStatus.active => (
            '${lead.interest} · ${attendance.elapsed}',
            'Ativo',
            AppColors.primaryDeep,
            700.0,
            lead.avatarColor,
            true,
          ),
          AttendanceStatus.scheduled => (
            attendance.schedule ?? '',
            'Agendado',
            const Color(0xFF9A6700),
            700.0,
            lead.avatarColor,
            false,
          ),
          AttendanceStatus.closed => (
            attendance.closedReason ?? '',
            'Encerrado',
            AppColors.inkMuted,
            500.0,
            AppColors.inkMuted,
            false,
          ),
        };
    return InkWell(
      onTap: () => _open(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            InitialsAvatar(
              initials: lead.initials,
              color: avatarColor,
              size: 52,
              showOnline: online,
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
                        shortLabel,
                        style: jk(
                          11.5,
                          labelWeight,
                          color: labelColor,
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
                          snippet,
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
                      if (MockData.hasApproved(lead)) ...[
                        const SizedBox(width: 6),
                        const StatusPill(
                          label: 'Crédito aprovado',
                          color: AppColors.primaryDeep,
                          background: AppColors.successSoft,
                          icon: Icons.check_circle_rounded,
                          dense: true,
                        ),
                      ],
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
