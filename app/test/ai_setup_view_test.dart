import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/features/ai_assistant/domain/ai_backend.dart';
import 'package:vsd/features/ai_assistant/domain/aws/aws_sso_session.dart';
import 'package:vsd/features/ai_assistant/presentation/components/ai_setup_view.dart';

void main() {
  Future<void> pumpView(
    WidgetTester tester, {
    required AiAuthMode mode,
    ValueChanged<AiAuthMode>? onModeChanged,
    AwsSsoDeviceAuthorization? pendingAuth,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AiSetupView(
            mode: mode,
            onModeChanged: onModeChanged ?? (_) {},
            onSaveApiKey: (_) {},
            onSignIn: (_) {},
            pendingAuth: pendingAuth,
          ),
        ),
      ),
    );
  }

  // The AWS form asks for six settings; the key form asks for one.
  final textFields = find.byType(TextField);

  testWidgets('bedrock mode shows the AWS settings form', (tester) async {
    await pumpView(tester, mode: AiAuthMode.bedrock);

    expect(tester.widgetList(textFields).length, 6);
    expect(find.text('sk-ant-...'), findsNothing);
  });

  testWidgets('api key mode shows a single key field', (tester) async {
    await pumpView(tester, mode: AiAuthMode.anthropicApiKey);

    expect(tester.widgetList(textFields).length, 1);
    expect(find.text('sk-ant-...'), findsOneWidget);
  });

  testWidgets('both providers are offered', (tester) async {
    await pumpView(tester, mode: AiAuthMode.bedrock);

    expect(find.text('AWS Bedrock'), findsOneWidget);
    expect(find.text('API key'), findsOneWidget);
  });

  testWidgets('picking the other provider reports it', (tester) async {
    AiAuthMode? picked;
    await pumpView(
      tester,
      mode: AiAuthMode.bedrock,
      onModeChanged: (mode) => picked = mode,
    );

    await tester.tap(find.text('API key'));
    await tester.pump();

    expect(picked, AiAuthMode.anthropicApiKey);
  });

  testWidgets('the provider picker is hidden while awaiting AWS approval', (tester) async {
    await pumpView(
      tester,
      mode: AiAuthMode.bedrock,
      pendingAuth: AwsSsoDeviceAuthorization(
        clientId: 'cid',
        clientSecret: 'secret',
        deviceCode: 'device',
        userCode: 'ABCD-EFGH',
        verificationUri: 'https://acme.awsapps.com/start/#/device',
        verificationUriComplete: 'https://acme.awsapps.com/start/#/device?user_code=ABCD-EFGH',
        interval: const Duration(seconds: 1),
        expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 10)),
      ),
    );

    // Switching provider mid-approval would abandon a sign-in in progress.
    expect(find.text('API key'), findsNothing);
    expect(find.text('ABCD-EFGH'), findsOneWidget);
  });

  test('mode names round-trip through storage, defaulting to bedrock', () {
    for (final mode in AiAuthMode.values) {
      expect(AiAuthMode.fromName(mode.name), mode);
    }

    expect(AiAuthMode.fromName(null), AiAuthMode.bedrock);
    expect(AiAuthMode.fromName('something-removed'), AiAuthMode.bedrock);
  });
}
