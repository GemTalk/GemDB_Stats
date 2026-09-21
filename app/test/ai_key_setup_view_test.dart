import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/features/ai_assistant/presentation/components/ai_key_setup_view.dart';

void main() {
  Future<void> pumpView(WidgetTester tester, {required bool hasExistingKey, void Function(String)? onSave}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AiKeySetupView(onSave: onSave ?? (_) {}, hasExistingKey: hasExistingKey),
        ),
      ),
    );
  }

  TextField field(WidgetTester tester) => tester.widget<TextField>(find.byType(TextField));
  String text(WidgetTester tester) => field(tester).controller!.text;
  final isDots = matches(RegExp(r'^•+$'));
  bool saveEnabled(WidgetTester tester) =>
      tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Save')).onPressed != null;

  Future<void> blur(WidgetTester tester) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
  }

  testWidgets('first-time entry is empty and readable', (tester) async {
    await pumpView(tester, hasExistingKey: false);

    expect(text(tester), isEmpty);
    expect(field(tester).obscureText, isFalse);
    expect(saveEnabled(tester), isFalse);

    await tester.enterText(find.byType(TextField), 'sk-ant-new');
    await tester.pump();
    expect(saveEnabled(tester), isTrue);
  });

  testWidgets('existing key shows obscured stand-in dots and cannot be saved as-is', (tester) async {
    await pumpView(tester, hasExistingKey: true);

    expect(text(tester), isNotEmpty);
    expect(text(tester), isDots);
    expect(field(tester).obscureText, isTrue);
    expect(saveEnabled(tester), isFalse);
  });

  testWidgets('focusing clears the stand-in; new text replaces it and is what gets saved', (tester) async {
    String? saved;
    await pumpView(tester, hasExistingKey: true, onSave: (k) => saved = k);

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(text(tester), isEmpty);
    expect(saveEnabled(tester), isFalse);

    await tester.enterText(find.byType(TextField), 'sk-ant-replacement');
    await tester.pump();
    expect(saveEnabled(tester), isTrue);

    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    expect(saved, 'sk-ant-replacement');
  });

  testWidgets('leaving the field empty brings the stand-in back', (tester) async {
    await pumpView(tester, hasExistingKey: true);

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(text(tester), isEmpty);

    await blur(tester);
    expect(text(tester), isDots);
    expect(saveEnabled(tester), isFalse);
  });

  testWidgets('leaving the field with a typed key keeps it', (tester) async {
    await pumpView(tester, hasExistingKey: true);

    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'sk-ant-typed');
    await blur(tester);

    expect(text(tester), 'sk-ant-typed');
    expect(saveEnabled(tester), isTrue);
  });
}
