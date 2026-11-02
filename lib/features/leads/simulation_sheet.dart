import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/common.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';

final _cpfPattern = RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$');

bool looksLikeCpf(String text) => _cpfPattern.hasMatch(text.trim());

String formatCpf(String digits) =>
    '${digits.substring(0, 3)}.${digits.substring(3, 6)}.'
    '${digits.substring(6, 9)}-${digits.substring(9, 11)}';

class SimulationSheet extends StatefulWidget {
  const SimulationSheet({super.key, required this.lead, this.onChanged});

  final Lead lead;
  final VoidCallback? onChanged;

  @override
  State<SimulationSheet> createState() => _SimulationSheetState();
}

class _SimulationSheetState extends State<SimulationSheet> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _refresh() {
    widget.onChanged?.call();
    setState(() {});
  }

  void _copy(String cpf) {
    Clipboard.setData(ClipboardData(text: cpf));
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('CPF copiado: $cpf')));
  }

  void _pick(CpfSimulation sim) {
    showCreditStatusPicker(
      context,
      widget.lead,
      sim,
      onChanged: _refresh,
    );
  }

  void _add() {
    final digits = _controller.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length != 11) {
      setState(() => _error = 'Digite os 11 dígitos do CPF');
      return;
    }
    final cpf = formatCpf(digits);
    MockData.addCpf(widget.lead, cpf);
    _controller.clear();
    setState(() => _error = null);
    _refresh();
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('CPF $cpf registrado · pendente')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final sims = MockData.simulationsFor(widget.lead);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetHandle(),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.credit_score_rounded,
                  size: 20,
                  color: AppColors.primaryDeep,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Simulações de crédito', style: AppText.h3),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.lead.name} · ${widget.lead.interest}',
                      style: AppText.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              StatusPill(
                label: '${sims.length} CPF${sims.length == 1 ? '' : 's'}',
                color: AppColors.primaryDeep,
                background: AppColors.primarySoft,
                dense: true,
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (sims.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                'Nenhum CPF registrado ainda. O cliente pode mandar vários.',
                style: AppText.body,
                textAlign: TextAlign.center,
              ),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 260),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: sims.length,
                separatorBuilder: (_, _) => const Divider(),
                itemBuilder: (context, i) => _SimulationRow(
                  sim: sims[i],
                  onPick: () => _pick(sims[i]),
                  onCopy: () => _copy(sims[i].cpf),
                ),
              ),
            ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.fromLTRB(14, 4, 6, 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (_) {
                      if (_error != null) setState(() => _error = null);
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    style: jk(14.5, 600, color: AppColors.ink),
                    cursorColor: AppColors.primaryDeep,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'Novo CPF (11 dígitos)',
                      hintStyle: AppText.body.copyWith(
                        color: AppColors.inkMuted,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                AppButton(
                  label: 'Adicionar',
                  icon: Icons.add_rounded,
                  variant: AppButtonVariant.primary,
                  compact: true,
                  onPressed: _add,
                ),
              ],
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _error!,
                style: jk(11.5, 600, color: AppColors.danger),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SimulationRow extends StatelessWidget {
  const _SimulationRow({
    required this.sim,
    required this.onPick,
    required this.onCopy,
  });

  final CpfSimulation sim;
  final VoidCallback onPick;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPick,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sim.cpf,
                    style: jk(14.5, 700, color: AppColors.ink, height: 1.2),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    [
                      if (sim.bank != null) sim.bank!,
                      sim.time,
                    ].join(' · '),
                    style: AppText.caption,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: onCopy,
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(
                  Icons.copy_rounded,
                  size: 17,
                  color: AppColors.inkMuted,
                ),
              ),
            ),
            const SizedBox(width: 6),
            StatusPill(
              label: sim.status.label,
              color: sim.status.color,
              background: sim.status.background,
              icon: sim.status.icon,
              dense: true,
            ),
          ],
        ),
      ),
    );
  }
}

void showCreditStatusPicker(
  BuildContext context,
  Lead lead,
  CpfSimulation sim, {
  VoidCallback? onChanged,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final bottomInset = MediaQuery.viewPaddingOf(sheetContext).bottom;
      return Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 14),
            Text('Resultado da simulação', style: AppText.h3),
            const SizedBox(height: 4),
            Text(
              'CPF ${sim.cpf} · ${lead.firstName}',
              style: AppText.caption,
            ),
            const SizedBox(height: 16),
            for (final status in CreditStatus.values) ...[
              _StatusOption(
                status: status,
                selected: sim.status == status,
                onTap: () {
                  MockData.setCreditStatus(lead, sim.cpf, status);
                  Navigator.of(sheetContext).pop();
                  onChanged?.call();
                  HapticFeedback.mediumImpact();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          '${sim.cpf} marcado como ${status.label.toLowerCase()}',
                        ),
                      ),
                    );
                },
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      );
    },
  );
}

class _StatusOption extends StatelessWidget {
  const _StatusOption({
    required this.status,
    required this.selected,
    required this.onTap,
  });

  final CreditStatus status;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? status.background : AppColors.surfaceAlt,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? status.color : Colors.transparent,
              width: selected ? 1.5 : 0,
            ),
          ),
          child: Row(
            children: [
              Icon(status.icon, size: 22, color: status.color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(status.label, style: AppText.bodyStrong),
                    const SizedBox(height: 2),
                    Text(status.hint, style: AppText.caption),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle_rounded, size: 20, color: status.color),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 4.5,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
