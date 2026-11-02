import 'dart:io';

import 'package:acelera/app.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _loadFonts() async {
  final bytes = File('assets/fonts/PlusJakartaSans.ttf').readAsBytesSync();
  final loader = FontLoader('Jakarta')
    ..addFont(Future<ByteData>.value(ByteData.sublistView(bytes)));
  await loader.load();
}

void main() {
  setUpAll(_loadFonts);

  testWidgets('navega entre as quatro abas em tela pequena', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const AceleraApp());
    await tester.pumpAndSettle();

    expect(find.text('Acelera'), findsOneWidget);
    expect(find.text('Novos contatos'), findsOneWidget);

    await tester.tap(find.text('Atender'));
    await tester.pumpAndSettle();
    expect(find.text('Atendimentos'), findsOneWidget);

    await tester.tap(find.text('Catálogo'));
    await tester.pumpAndSettle();
    expect(find.text('Catálogo'), findsWidgets);

    await tester.tap(find.text('Pós-venda'));
    await tester.pumpAndSettle();
    expect(find.text('Pós-vendas'), findsOneWidget);

    await tester.tap(find.text('Novos'));
    await tester.pumpAndSettle();
    expect(find.text('Novos contatos'), findsOneWidget);
  });

  testWidgets('funciona com texto ampliado em tela pequena', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.2;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(const AceleraApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Atender'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Catálogo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pós-venda'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Novos'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Marina Alves'));
    await tester.pumpAndSettle();
    expect(find.textContaining('A placa da'), findsOneWidget);
  });

  testWidgets('abre um contato e assume o atendimento', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const AceleraApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Marina Alves'));
    await tester.pumpAndSettle();
    expect(find.text('Assumir atendimento'), findsOneWidget);

    await tester.tap(find.text('Assumir atendimento'));
    await tester.pumpAndSettle();
    expect(find.text('Cliente assumido!'), findsOneWidget);

    await tester.tap(find.text('Começar atendimento'));
    await tester.pumpAndSettle();
    expect(find.text('Mensagem'), findsOneWidget);
    expect(find.text('Agendar'), findsOneWidget);
  });
}
