import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/bike_image.dart';
import '../../core/widgets/common.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import 'client_profile_page.dart';
import 'simulation_sheet.dart';

class LeadDetailPage extends StatefulWidget {
  const LeadDetailPage({
    super.key,
    required this.lead,
    this.attendanceStatus,
    this.schedule,
    this.closedReason,
    this.elapsed,
  });

  final Lead lead;
  final AttendanceStatus? attendanceStatus;
  final String? schedule;
  final String? closedReason;
  final String? elapsed;

  @override
  State<LeadDetailPage> createState() => _LeadDetailPageState();
}

class _LeadDetailPageState extends State<LeadDetailPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  late List<ChatMessage> _messages;
  AttendanceStatus? _status;

  @override
  void initState() {
    super.initState();
    _status = widget.attendanceStatus;
    _messages = MockData.chatFor(widget.lead, _status);
    _focusNode.addListener(_onFocusChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) _scrollToBottom(animate: true);
  }

  void _scrollToBottom({bool animate = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final target = _scrollController.position.maxScrollExtent;
      if (animate) {
        _scrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
        );
      } else {
        _scrollController.jumpTo(target);
      }
    });
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final now = TimeOfDay.now();
    final time =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    setState(() {
      _messages.add(
        ChatMessage(text: text, time: time, fromLead: false, read: false),
      );
    });
    _controller.clear();
    HapticFeedback.lightImpact();
    _scrollToBottom(animate: true);
  }

  void _showAssumed() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _AssumedSheet(
        lead: widget.lead,
        onStart: () {
          Navigator.of(sheetContext).pop();
          setState(() {
            _status = AttendanceStatus.active;
            _messages.addAll(MockData.consultantChat(widget.lead));
          });
          _scrollToBottom(animate: true);
        },
      ),
    );
  }

  void _showContactInfo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ClientProfilePage(
          lead: widget.lead,
          status: _status,
          schedule: widget.schedule,
        ),
      ),
    );
  }

  void _showSimulation() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => SimulationSheet(
        lead: widget.lead,
        onChanged: () => setState(() {}),
      ),
    );
  }

  void _showMore() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _MoreSheet(
        onContact: () {
          Navigator.of(context).pop();
          _showContactInfo();
        },
        onAction: (label) {
          Navigator.of(context).pop();
          _toast('$label · em breve');
        },
      ),
    );
  }

  void _showAttach() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        const options = [
          (Icons.photo_camera_rounded, 'Câmera', Color(0xFF7C5CFF)),
          (Icons.photo_library_rounded, 'Galeria', Color(0xFFEC4899)),
          (Icons.insert_drive_file_rounded, 'Documento', Color(0xFF1B63FF)),
          (Icons.location_on_rounded, 'Localização', Color(0xFF0FA968)),
          (Icons.two_wheeler_rounded, 'Catálogo', Color(0xFFF59E0B)),
        ];
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
              const SizedBox(height: 18),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  for (final (icon, label, color) in options)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        _toast('$label · em breve');
                      },
                      child: SizedBox(
                        width: 68,
                        child: Column(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(icon, color: color, size: 24),
                            ),
                            const SizedBox(height: 6),
                            Text(label, style: AppText.caption),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String get _subtitle => switch (_status) {
    AttendanceStatus.active => 'online',
    AttendanceStatus.scheduled => 'visto por último hoje',
    AttendanceStatus.closed => 'visto por último ontem',
    null => 'online',
  };

  String? get _statusNotice => switch (_status) {
    AttendanceStatus.active =>
      'Atendimento em andamento · ${widget.elapsed ?? 'agora'}',
    AttendanceStatus.scheduled =>
      'Agendado para ${widget.schedule ?? 'horário confirmado'}',
    AttendanceStatus.closed =>
      'Atendimento encerrado · ${widget.closedReason ?? 'voltou para a fila'}',
    null => null,
  };

  int get _itemCount {
    final notice = _statusNotice != null ? 1 : 0;
    return 2 + notice + _messages.length;
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == 0) return const _DateChip(label: 'HOJE');
    if (index == 1) {
      return const _SystemNotice(
        icon: Icons.lock_rounded,
        text: 'As mensagens são protegidas com criptografia de ponta a ponta.',
      );
    }
    final notice = _statusNotice;
    if (notice != null && index == 2) {
      return _SystemNotice(
        icon: switch (_status) {
          AttendanceStatus.active => Icons.forum_rounded,
          AttendanceStatus.scheduled => Icons.event_available_rounded,
          AttendanceStatus.closed => Icons.check_circle_outline_rounded,
          null => Icons.info_outline_rounded,
        },
        text: notice,
      );
    }
    final messageIndex = index - 2 - (notice != null ? 1 : 0);
    return _MessageBubble(
      message: _messages[messageIndex],
      lead: widget.lead,
      onCpfTap: _showSimulation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: ChatColors.wallpaper,
        body: Column(
          children: [
            _ChatHeader(
              lead: widget.lead,
              subtitle: _subtitle,
              onBack: () => Navigator.of(context).pop(),
              onInfo: _showContactInfo,
              onCall: () => _toast('Ligando para ${widget.lead.phone}'),
              onVideo: () => _toast('Chamada de vídeo · em breve'),
              onMore: _showMore,
            ),
            Expanded(
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: RepaintBoundary(
                      child: CustomPaint(painter: _DoodlePainter()),
                    ),
                  ),
                  ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 12, 10, 14),
                    itemCount: _itemCount,
                    itemBuilder: _buildItem,
                  ),
                ],
              ),
            ),
            _Composer(
              status: _status,
              controller: _controller,
              focusNode: _focusNode,
              onSend: _send,
              onEmoji: () => _toast('Emojis · em breve'),
              onAttach: _showAttach,
              onCamera: () => _toast('Câmera · em breve'),
              onMic: () => _toast('Segure para gravar um áudio'),
              onAssume: _showAssumed,
              onAction: _toast,
              onSimulation: _showSimulation,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({
    required this.lead,
    required this.subtitle,
    required this.onBack,
    required this.onInfo,
    required this.onCall,
    required this.onVideo,
    required this.onMore,
  });

  final Lead lead;
  final String subtitle;
  final VoidCallback onBack;
  final VoidCallback onInfo;
  final VoidCallback onCall;
  final VoidCallback onVideo;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ChatColors.header,
        boxShadow: [
          BoxShadow(color: Color(0x2B000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 58,
          child: Row(
            children: [
              _HeaderButton(icon: Icons.arrow_back_rounded, onTap: onBack),
              const SizedBox(width: 2),
              GestureDetector(
                onTap: onInfo,
                behavior: HitTestBehavior.opaque,
                child: InitialsAvatar(
                  initials: lead.initials,
                  color: lead.avatarColor,
                  size: 39,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: onInfo,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lead.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: jk(
                          16,
                          700,
                          color: Colors.white,
                          height: 1.15,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: jk(
                          11.5,
                          500,
                          color: Colors.white.withValues(alpha: 0.82),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _HeaderButton(icon: Icons.videocam_rounded, onTap: onVideo),
              _HeaderButton(icon: Icons.call_rounded, onTap: onCall),
              _HeaderButton(icon: Icons.more_vert_rounded, onTap: onMore),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 22),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      splashRadius: 22,
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xE6FFFFFF),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          label,
          style: jk(
            10.5,
            700,
            color: ChatColors.systemText,
            height: 1.2,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}

class _SystemNotice extends StatelessWidget {
  const _SystemNotice({this.icon, required this.text});

  final IconData? icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ChatColors.system,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: ChatColors.systemText),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: jk(11.5, 500, color: ChatColors.systemText, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.lead,
    this.onCpfTap,
  });

  final ChatMessage message;
  final Lead lead;
  final VoidCallback? onCpfTap;

  @override
  Widget build(BuildContext context) {
    final outgoing = !message.fromLead;
    final bubbleColor = outgoing ? ChatColors.bubbleOut : ChatColors.bubbleIn;
    final maxWidth = math.min(MediaQuery.sizeOf(context).width * 0.8, 560.0);
    final isCpf = message.fromLead && looksLikeCpf(message.text);

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (message.automated) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bolt_rounded, size: 12, color: ChatColors.accent),
              const SizedBox(width: 3),
              Text(
                'Resposta automática',
                style: jk(
                  10,
                  700,
                  color: ChatColors.accent,
                  height: 1.2,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        if (isCpf)
          _SimulationCard(lead: lead, cpf: message.text.trim(), onTap: onCpfTap)
        else if (message.kind == ChatMessageKind.bike) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              message.text,
              style: jk(14.2, 500, color: ChatColors.text, height: 1.34),
            ),
          ),
          const SizedBox(height: 8),
          _BikePreview(lead: lead),
        ] else if (message.kind == ChatMessageKind.bikes) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              message.text,
              style: jk(14.2, 500, color: ChatColors.text, height: 1.34),
            ),
          ),
          const SizedBox(height: 8),
          _BikeOptionsPreview(lead: lead),
        ] else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              message.text,
              style: jk(14.2, 500, color: ChatColors.text, height: 1.34),
            ),
          ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(message.time, style: jk(10, 500, color: ChatColors.meta)),
              if (outgoing) ...[
                const SizedBox(width: 3),
                Icon(
                  Icons.done_all_rounded,
                  size: 15,
                  color: message.read ? ChatColors.tickRead : ChatColors.meta,
                ),
              ],
            ],
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Align(
        alignment: outgoing ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!outgoing) _BubbleTail(color: bubbleColor, outgoing: false),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(7, 6, 7, 4),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(outgoing ? 12 : 3),
                      topRight: Radius.circular(outgoing ? 3 : 12),
                      bottomLeft: const Radius.circular(12),
                      bottomRight: const Radius.circular(12),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: body,
                ),
              ),
              if (outgoing) _BubbleTail(color: bubbleColor, outgoing: true),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimulationCard extends StatelessWidget {
  const _SimulationCard({
    required this.lead,
    required this.cpf,
    this.onTap,
  });

  final Lead lead;
  final String cpf;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final status = MockData.creditStatusFor(lead, cpf);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 218,
        padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
        decoration: BoxDecoration(
          color: ChatColors.inputBar,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.credit_score_rounded,
                  size: 14,
                  color: ChatColors.accent,
                ),
                const SizedBox(width: 4),
                Text(
                  'SIMULAÇÃO DE CRÉDITO',
                  style: jk(
                    9.5,
                    700,
                    color: ChatColors.meta,
                    height: 1.2,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              cpf,
              style: jk(
                15.5,
                800,
                color: ChatColors.text,
                height: 1.15,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 7),
            StatusPill(
              label: status.label,
              color: status.color,
              background: status.background,
              icon: status.icon,
              dense: true,
            ),
            const SizedBox(height: 5),
            Text(
              'Toque para registrar o resultado',
              style: jk(9.5, 500, color: ChatColors.hint, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}

class _BikePreview extends StatelessWidget {
  const _BikePreview({required this.lead});

  final Lead lead;

  @override
  Widget build(BuildContext context) {
    final bike = MockData.bikeFor(lead.interest);
    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: 238,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BikeImage(
              asset: lead.image,
              width: 238,
              height: 132,
              fit: BoxFit.cover,
              cacheWidth: 480,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(9, 7, 9, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lead.interest,
                    style: jk(13, 700, color: ChatColors.text, height: 1.25),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    bike == null
                        ? 'Disponível na loja'
                        : '${_money(bike.price)} · 36x de ${_money(bike.monthly)}',
                    style: jk(11, 500, color: ChatColors.meta, height: 1.3),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.open_in_new_rounded,
                        size: 11,
                        color: ChatColors.accent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Ver no catálogo',
                        style: jk(10.5, 600, color: ChatColors.accent),
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

class _BikeOptionsPreview extends StatelessWidget {
  const _BikeOptionsPreview({required this.lead});

  final Lead lead;

  @override
  Widget build(BuildContext context) {
    final bike = MockData.bikeFor(lead.interest);
    final basePrice = bike?.price ?? 18990;
    const variants = [
      ('2024', '0 km', 1.0, 'Nova'),
      ('2023', '8.400 km', 0.87, 'Seminova'),
      ('2022', '14.200 km', 0.79, 'Usada'),
    ];
    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: 252,
        color: Colors.white,
        child: Column(
          children: [
            for (var i = 0; i < variants.length; i++)
              Builder(
                builder: (context) {
                  final (year, km, factor, badge) = variants[i];
                  return Column(
                    children: [
                      if (i > 0) const Divider(
                        height: 1,
                        thickness: 0.8,
                        color: Color(0xFFE9EDF2),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
                        child: Row(
                          children: [
                            BikeImage(
                              asset: lead.image,
                              width: 52,
                              height: 38,
                              radius: 8,
                              cacheWidth: 156,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${lead.interest} $year',
                                    style: jk(
                                      12.5,
                                      700,
                                      color: ChatColors.text,
                                      height: 1.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    '$km · ${MockData.money((basePrice * factor).round())} · $badge',
                                    style: jk(
                                      10.5,
                                      500,
                                      color: ChatColors.meta,
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (i == 0)
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 16,
                                color: ChatColors.accent,
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _BubbleTail extends StatelessWidget {
  const _BubbleTail({required this.color, required this.outgoing});

  final Color color;
  final bool outgoing;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(9, 12),
      painter: _TailPainter(color: color, outgoing: outgoing),
    );
  }
}

class _TailPainter extends CustomPainter {
  const _TailPainter({required this.color, required this.outgoing});

  final Color color;
  final bool outgoing;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    if (outgoing) {
      path
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..quadraticBezierTo(
          size.width * 0.35,
          size.height * 0.55,
          0,
          size.height,
        );
    } else {
      path
        ..moveTo(size.width, 0)
        ..lineTo(0, 0)
        ..quadraticBezierTo(
          size.width * 0.65,
          size.height * 0.55,
          size.width,
          size.height,
        );
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TailPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.outgoing != outgoing;
}

class _DoodlePainter extends CustomPainter {
  const _DoodlePainter();

  static const _glyphs = <IconData>[
    Icons.chat_bubble_outline_rounded,
    Icons.favorite_border_rounded,
    Icons.two_wheeler_rounded,
    Icons.star_border_rounded,
    Icons.camera_alt_outlined,
    Icons.explore_outlined,
    Icons.emoji_emotions_outlined,
    Icons.local_cafe_outlined,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 88.0;
    var row = 0;
    for (var y = 18.0; y < size.height; y += spacing, row++) {
      final stagger = row.isEven ? 14.0 : 58.0;
      var column = 0;
      for (var x = stagger; x < size.width; x += spacing) {
        final icon = _glyphs[(row + column++) % _glyphs.length];
        final painter = TextPainter(
          text: TextSpan(
            text: String.fromCharCode(icon.codePoint),
            style: TextStyle(
              fontFamily: icon.fontFamily,
              package: icon.fontPackage,
              fontSize: 21,
              color: ChatColors.doodle,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        painter.paint(canvas, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRepaint(_DoodlePainter oldDelegate) => false;
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.status,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onEmoji,
    required this.onAttach,
    required this.onCamera,
    required this.onMic,
    required this.onAssume,
    required this.onAction,
    required this.onSimulation,
  });

  final AttendanceStatus? status;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final VoidCallback onEmoji;
  final VoidCallback onAttach;
  final VoidCallback onCamera;
  final VoidCallback onMic;
  final VoidCallback onAssume;
  final ValueChanged<String> onAction;
  final VoidCallback onSimulation;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ChatColors.inputBar,
      child: SafeArea(
        top: false,
        child: switch (status) {
          null => Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: AppButton(
              label: 'Assumir atendimento',
              icon: Icons.bolt_rounded,
              trailingIcon: Icons.arrow_forward_rounded,
              variant: AppButtonVariant.lime,
              expand: true,
              onPressed: onAssume,
            ),
          ),
          AttendanceStatus.closed => Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: AppButton(
              label: 'Reabrir atendimento',
              icon: Icons.refresh_rounded,
              variant: AppButtonVariant.outline,
              expand: true,
              onPressed: () => onAction('Reabrir atendimento'),
            ),
          ),
          AttendanceStatus.active || AttendanceStatus.scheduled =>
            _ActiveComposer(
              controller: controller,
              focusNode: focusNode,
              status: status!,
              onSend: onSend,
              onEmoji: onEmoji,
              onAttach: onAttach,
              onCamera: onCamera,
              onMic: onMic,
              onAction: onAction,
              onSimulation: onSimulation,
            ),
        },
      ),
    );
  }
}

class _ActiveComposer extends StatelessWidget {
  const _ActiveComposer({
    required this.controller,
    required this.focusNode,
    required this.status,
    required this.onSend,
    required this.onEmoji,
    required this.onAttach,
    required this.onCamera,
    required this.onMic,
    required this.onAction,
    required this.onSimulation,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final AttendanceStatus status;
  final VoidCallback onSend;
  final VoidCallback onEmoji;
  final VoidCallback onAttach;
  final VoidCallback onCamera;
  final VoidCallback onMic;
  final ValueChanged<String> onAction;
  final VoidCallback onSimulation;

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!keyboardOpen) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  _QuickChip(
                    icon: Icons.credit_score_rounded,
                    label: 'Crédito',
                    color: AppColors.primaryDeep,
                    onTap: onSimulation,
                  ),
                  const SizedBox(width: 6),
                  if (status == AttendanceStatus.active) ...[
                    _QuickChip(
                      icon: Icons.event_rounded,
                      label: 'Agendar',
                      color: const Color(0xFF9A6700),
                      onTap: () => onAction('Abrir agendamento'),
                    ),
                    const SizedBox(width: 6),
                    _QuickChip(
                      icon: Icons.sell_rounded,
                      label: 'Vender',
                      color: AppColors.success,
                      onTap: () => onAction('Registrar venda'),
                    ),
                    const SizedBox(width: 6),
                    _QuickChip(
                      icon: Icons.close_rounded,
                      label: 'Encerrar',
                      color: AppColors.danger,
                      onTap: () => onAction('Encerrar atendimento'),
                    ),
                  ] else ...[
                    _QuickChip(
                      icon: Icons.edit_calendar_rounded,
                      label: 'Reagendar',
                      color: const Color(0xFF9A6700),
                      onTap: () => onAction('Reagendar atendimento'),
                    ),
                    const SizedBox(width: 6),
                    _QuickChip(
                      icon: Icons.check_rounded,
                      label: 'Compareceu',
                      color: AppColors.success,
                      onTap: () => onAction('Cliente compareceu'),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 7),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _InputField(
                  controller: controller,
                  focusNode: focusNode,
                  onEmoji: onEmoji,
                  onAttach: onAttach,
                  onCamera: onCamera,
                  onSend: onSend,
                ),
              ),
              const SizedBox(width: 6),
              _SendButton(controller: controller, onSend: onSend, onMic: onMic),
            ],
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.focusNode,
    required this.onEmoji,
    required this.onAttach,
    required this.onCamera,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onEmoji;
  final VoidCallback onAttach;
  final VoidCallback onCamera;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.only(left: 2, right: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _ComposerIcon(icon: Icons.emoji_emotions_outlined, onTap: onEmoji),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              style: jk(14.5, 500, color: ChatColors.text),
              cursorColor: ChatColors.accent,
              cursorWidth: 2,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              maxLines: 4,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Mensagem',
                hintStyle: jk(14.5, 500, color: ChatColors.hint),
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
              ),
            ),
          ),
          _ComposerIcon(icon: Icons.attach_file_rounded, onTap: onAttach),
          _ComposerIcon(icon: Icons.photo_camera_outlined, onTap: onCamera),
        ],
      ),
    );
  }
}

class _ComposerIcon extends StatelessWidget {
  const _ComposerIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, size: 23, color: ChatColors.hint),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 38, height: 48),
      splashRadius: 20,
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.controller,
    required this.onSend,
    required this.onMic,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onMic;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final hasText = value.text.trim().isNotEmpty;
        return Material(
          color: ChatColors.accent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: hasText ? onSend : onMic,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 48,
              height: 48,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: Icon(
                  hasText ? Icons.send_rounded : Icons.mic_rounded,
                  key: ValueKey<bool>(hasText),
                  color: Colors.white,
                  size: 23,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE2E6EA)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 5),
              Text(label, style: jk(12, 600, color: ChatColors.text)),
            ],
          ),
        ),
      ),
    );
  }
}

String _money(int value) {
  final digits = value.toString();
  final buffer = StringBuffer('R\$ ');
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}

class _AssumedSheet extends StatelessWidget {
  const _AssumedSheet({required this.lead, required this.onStart});

  final Lead lead;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.fromLTRB(24, 12, 24, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetHandle(),
          const SizedBox(height: 22),
          Container(
            width: 74,
            height: 74,
            decoration: const BoxDecoration(
              color: AppColors.lime,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 36,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 16),
          Text('Cliente assumido!', style: AppText.h2),
          const SizedBox(height: 6),
          Text(
            '${lead.firstName} saiu dos novos contatos e agora está na sua carteira.',
            style: AppText.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: _SheetStat(label: 'Tempo de resposta', value: '0s'),
                ),
                Container(width: 1, height: 30, color: AppColors.border),
                const Expanded(
                  child: _SheetStat(label: 'Na sua carteira', value: '4'),
                ),
                Container(width: 1, height: 30, color: AppColors.border),
                const Expanded(
                  child: _SheetStat(label: 'Novos contatos', value: '11'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          AppButton(
            label: 'Começar atendimento',
            trailingIcon: Icons.arrow_forward_rounded,
            variant: AppButtonVariant.lime,
            expand: true,
            onPressed: onStart,
          ),
        ],
      ),
    );
  }
}

class _SheetStat extends StatelessWidget {
  const _SheetStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppText.moneySmall),
        const SizedBox(height: 2),
        Text(label, style: AppText.caption, textAlign: TextAlign.center),
      ],
    );
  }
}

class _MoreSheet extends StatelessWidget {
  const _MoreSheet({required this.onContact, required this.onAction});

  final VoidCallback onContact;
  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    const actions = [
      (Icons.person_outline_rounded, 'Perfil do cliente', true),
      (Icons.event_rounded, 'Agendar atendimento', false),
      (Icons.sell_rounded, 'Registrar venda', false),
      (Icons.close_rounded, 'Encerrar atendimento', false),
      (Icons.flag_outlined, 'Marcar como prioritário', false),
      (Icons.block_rounded, 'Marcar como spam', false),
    ];
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
          const SizedBox(height: 16),
          for (final (icon, label, isContact) in actions)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => isContact ? onContact() : onAction(label),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceAlt,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, size: 19, color: AppColors.inkSoft),
                      ),
                      const SizedBox(width: 12),
                      Text(label, style: AppText.bodyStrong),
                      const Spacer(),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.inkMuted,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
