import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/bike_image.dart';
import '../../core/widgets/common.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../catalogo/bike_detail_page.dart';
import 'simulation_sheet.dart';

class ClientProfilePage extends StatelessWidget {
  const ClientProfilePage({
    super.key,
    required this.lead,
    this.status,
    this.schedule,
  });

  final Lead lead;
  final AttendanceStatus? status;
  final String? schedule;

  void _copy(BuildContext context, String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$label copiado: $value')),
      );
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
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
            titleSpacing: 4,
            title: Text(
              'Perfil do cliente',
              style: jk(17.5, 700, color: Colors.white, letterSpacing: -0.2),
            ),
            actions: [
              IconButton(
                onPressed: () =>
                    _toast(context, 'Perfil editável · em breve'),
                icon: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 21,
                ),
                tooltip: 'Editar',
              ),
              const SizedBox(width: 4),
            ],
          ),
          SliverToBoxAdapter(child: _header()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Ligar',
                      icon: Icons.call_rounded,
                      variant: AppButtonVariant.outline,
                      onPressed: () =>
                          _toast(context, 'Ligando para ${lead.phoneSpaced}'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppButton(
                      label: 'WhatsApp',
                      icon: Icons.chat_bubble_rounded,
                      variant: AppButtonVariant.outline,
                      onPressed: () =>
                          _toast(context, 'Abrindo WhatsApp de ${lead.firstName}'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppButton(
                      label: 'Agendar',
                      icon: Icons.event_rounded,
                      variant: AppButtonVariant.primary,
                      onPressed: () => _toast(context, 'Novo agendamento'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _Section(
              title: 'DADOS DE CONTATO',
              subtitle: 'Toque na linha para copiar',
              child: AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _CopyRow(
                      context: context,
                      onCopy: () => _copy(
                        context,
                        'Telefone',
                        lead.phoneSpaced,
                      ),
                      icon: Icons.phone_iphone_rounded,
                      label: 'Telefone',
                      value: lead.phoneSpaced,
                    ),
                    _CopyRow(
                      context: context,
                      onCopy: () => _copy(context, 'CPF', lead.cpf),
                      icon: Icons.badge_outlined,
                      label: 'CPF',
                      value: lead.cpf,
                    ),
                    _CopyRow(
                      context: context,
                      onCopy: () => _copy(context, 'E-mail', lead.email),
                      icon: Icons.alternate_email_rounded,
                      label: 'E-mail',
                      value: lead.email,
                    ),
                    _InfoRowSecondary(
                      icon: Icons.cake_outlined,
                      label: 'Nascimento',
                      value: lead.birthDate,
                    ),
                    _InfoRowSecondary(
                      icon: Icons.work_outline_rounded,
                      label: 'Profissão',
                      value: lead.profession,
                    ),
                    _CopyRow(
                      context: context,
                      onCopy: () => _copy(context, 'Endereço', lead.address),
                      icon: Icons.home_outlined,
                      label: 'Endereço',
                      value: lead.address,
                      last: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _Section(
              title: 'MOTO DE INTERESSE',
              child: Column(
                children: [
                  AppCard(
                    padding: const EdgeInsets.all(12),
                    onTap: () {
                      final bike = MockData.bikeFor(lead.interest);
                      if (bike == null) {
                        _toast(context, '${lead.interest} · em breve');
                        return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => BikeDetailPage(
                            bike: bike,
                            heroTag: 'bike-${bike.id}',
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        BikeImage(
                          asset: lead.image,
                          width: 96,
                          height: 72,
                          radius: 14,
                          cacheWidth: 288,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lead.interest,
                                style: AppText.h3,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const AppTag(
                                    label: 'Escolhida pelo cliente',
                                    icon: Icons.check_circle_rounded,
                                    color: AppColors.primaryDeep,
                                    background: AppColors.successSoft,
                                    dense: true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _bikePriceLine(),
                                style: AppText.caption,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.successSoft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _copy(context, 'Placa', lead.plate),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.confirmation_number_outlined,
                            size: 20,
                            color: AppColors.primaryDeep,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PLACA DA MOTO ESCOLHIDA',
                                style: jk(
                                  9.5,
                                  700,
                                  color: AppColors.inkSoft,
                                  height: 1.2,
                                  letterSpacing: 0.6,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                lead.plate,
                                style: jk(
                                  17,
                                  800,
                                  color: AppColors.ink,
                                  height: 1.15,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.copy_rounded,
                            size: 18,
                            color: AppColors.primaryDeep,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Copiar',
                            style: jk(
                              12,
                              700,
                              color: AppColors.primaryDeep,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _InfoRowSecondary(
                          icon: Icons.calendar_month_rounded,
                          label: 'Ano do modelo',
                          value: lead.bikeYear,
                        ),
                        _InfoRowSecondary(
                          icon: Icons.speed_rounded,
                          label: 'Quilometragem',
                          value: lead.bikeKm,
                        ),
                        _InfoRowSecondary(
                          icon: Icons.account_balance_wallet_outlined,
                          label: 'Financiamento',
                          value: _financeSummary(),
                          last: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _Section(
              title: 'CRÉDITO · SIMULAÇÕES',
              subtitle: 'Toque para registrar aprovado ou reprovado',
              child: _CreditSection(lead: lead),
            ),
          ),
          SliverToBoxAdapter(
            child: _Section(
              title: 'PREFERÊNCIAS',
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final tag in lead.tags) AppTag(label: tag),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(lead.note, style: AppText.body.copyWith(height: 1.5)),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _Section(
              title: 'HISTÓRICO',
              child: AppCard(
                child: _Timeline(
                  events: [
                    _Event(
                      title: 'Contato recebido via ${lead.source.label}',
                      time: '${lead.timeAgo} · 09:41',
                      color: AppColors.primary,
                    ),
                    const _Event(
                      title: 'Atendimento automático enviou 3 opções',
                      time: '09:42',
                      color: AppColors.violet,
                    ),
                    _Event(
                      title: 'Cliente escolheu a ${lead.interest} 2024',
                      time: '09:44',
                      color: AppColors.primaryDeep,
                    ),
                    _Event(
                      title: 'Enviou CPF para simulação de crédito',
                      time: '09:46',
                      color: AppColors.success,
                    ),
                    _Event(
                      title:
                          status != null
                              ? 'Atendimento ativo com você'
                              : 'Aguardando assumir o atendimento',
                      time: status != null ? 'agora' : 'pendente',
                      color: status != null
                          ? AppColors.success
                          : AppColors.warning,
                      last: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: Column(
                children: [
                  AppButton(
                    label: 'Abrir conversa',
                    icon: Icons.chat_rounded,
                    trailingIcon: Icons.arrow_forward_rounded,
                    variant: AppButtonVariant.lime,
                    expand: true,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        children: [
          InitialsAvatar(
            initials: lead.initials,
            color: lead.avatarColor,
            size: 92,
            showOnline: lead.temperature == LeadTemperature.hot,
          ),
          const SizedBox(height: 12),
          Text(
            lead.name,
            style: AppText.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '${lead.phoneSpaced} · ${lead.city.split(' · ').first}',
            style: AppText.body,
          ),
          const SizedBox(height: 10),
          StatusPill(
            label: switch (status) {
              AttendanceStatus.active => 'Em atendimento',
              AttendanceStatus.scheduled =>
                schedule ?? 'Agendado',
              AttendanceStatus.closed => 'Atendimento encerrado',
              null => 'Aguardando atendimento',
            },
            icon: switch (status) {
              AttendanceStatus.active => Icons.forum_rounded,
              AttendanceStatus.scheduled => Icons.event_rounded,
              AttendanceStatus.closed => Icons.check_circle_outline_rounded,
              null => Icons.hourglass_top_rounded,
            },
            color: switch (status) {
              AttendanceStatus.active => AppColors.primaryDeep,
              AttendanceStatus.scheduled => const Color(0xFF9A6700),
              AttendanceStatus.closed => AppColors.inkSoft,
              null => AppColors.primaryDeep,
            },
            background: switch (status) {
              AttendanceStatus.active => AppColors.primarySoft,
              AttendanceStatus.scheduled => AppColors.warningSoft,
              AttendanceStatus.closed => AppColors.surfaceAlt,
              null => AppColors.primarySoft,
            },
          ),
        ],
      ),
    );
  }

  String _bikePriceLine() {
    final bike = MockData.bikeFor(lead.interest);
    if (bike == null) {
      return 'Sob consulta · ${lead.bikeYear} · ${lead.bikeKm}';
    }
    return '${MockData.money(bike.price)} · 36x de ${MockData.money(bike.monthly)}';
  }

  String _financeSummary() {
    final bike = MockData.bikeFor(lead.interest);
    return bike == null
        ? 'Simulação enviada · em análise'
        : 'Entrada R\$ 1.200 · 36x de ${MockData.money(bike.monthly)}';
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, this.subtitle, required this.child});

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppText.overline),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!, style: AppText.caption),
          ],
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _CopyRow extends StatelessWidget {
  const _CopyRow({
    required this.context,
    required this.onCopy,
    required this.icon,
    required this.label,
    required this.value,
    this.last = false,
  });

  final BuildContext context;
  final VoidCallback onCopy;
  final IconData icon;
  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onCopy,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, size: 18, color: AppColors.primaryDeep),
                ),
                const SizedBox(width: 12),
                Text(label, style: AppText.body),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: AppText.bodyStrong,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.copy_rounded,
                  size: 17,
                  color: AppColors.primaryDeep,
                ),
              ],
            ),
          ),
        ),
        if (!last) const Divider(),
      ],
    );
  }
}

class _InfoRowSecondary extends StatelessWidget {
  const _InfoRowSecondary({
    required this.icon,
    required this.label,
    required this.value,
    this.last = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 18, color: AppColors.inkSoft),
              ),
              const SizedBox(width: 12),
              Text(label, style: AppText.body),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: AppText.bodyStrong,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        if (!last) const Divider(),
      ],
    );
  }
}

class _Event {
  const _Event({
    required this.title,
    required this.time,
    required this.color,
    this.last = false,
  });

  final String title;
  final String time;
  final Color color;
  final bool last;
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.events});

  final List<_Event> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final event in events)
          SizedBox(
            height: event.last ? 42 : 56,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                  child: Column(
                    children: [
                      Container(
                        width: 11,
                        height: 11,
                        margin: const EdgeInsets.only(top: 3),
                        decoration: BoxDecoration(
                          color: event.color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: event.color.withValues(alpha: 0.2),
                            width: 3,
                          ),
                        ),
                      ),
                      if (!event.last)
                        Expanded(
                          child: Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            color: AppColors.border,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.title, style: AppText.bodyStrong),
                      const SizedBox(height: 2),
                      Text(event.time, style: AppText.caption),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _CreditSection extends StatefulWidget {
  const _CreditSection({required this.lead});

  final Lead lead;

  @override
  State<_CreditSection> createState() => _CreditSectionState();
}

class _CreditSectionState extends State<_CreditSection> {
  void _openSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => SimulationSheet(
        lead: widget.lead,
        onChanged: () => setState(() {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sims = MockData.simulationsFor(widget.lead);
    final approved = sims.where((s) => s.status == CreditStatus.approved).length;
    return AppCard(
      padding: EdgeInsets.zero,
      child: sims.isEmpty
          ? InkWell(
              onTap: _openSheet,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        size: 18,
                        color: AppColors.inkSoft,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Registrar primeiro CPF',
                        style: AppText.bodyStrong,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: AppColors.inkMuted,
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                for (var i = 0; i < sims.length; i++)
                  InkWell(
                    onTap: _openSheet,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: sims[i].status.background,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Icon(
                              sims[i].status.icon,
                              size: 18,
                              color: sims[i].status.color,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sims[i].cpf,
                                  style: AppText.bodyStrong,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  [
                                    if (sims[i].bank != null) sims[i].bank!,
                                    sims[i].time,
                                  ].join(' · '),
                                  style: AppText.caption,
                                ),
                              ],
                            ),
                          ),
                          StatusPill(
                            label: sims[i].status.label,
                            color: sims[i].status.color,
                            background: sims[i].status.background,
                            icon: sims[i].status.icon,
                            dense: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                const Divider(),
                InkWell(
                  onTap: _openSheet,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add_rounded,
                          size: 18,
                          color: AppColors.primaryDeep,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            approved > 0
                                ? 'Gerenciar CPFs · $approved aprovado${approved == 1 ? '' : 's'}'
                                : 'Adicionar outro CPF',
                            style: jk(13.5, 700, color: AppColors.primaryDeep),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: AppColors.inkMuted,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
