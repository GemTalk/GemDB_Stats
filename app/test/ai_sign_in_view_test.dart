import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/features/ai_assistant/domain/aws/aws_sso_config.dart';
import 'package:vsd/features/ai_assistant/domain/aws/aws_sso_session.dart';
import 'package:vsd/features/ai_assistant/presentation/components/ai_sign_in_view.dart';

void main() {
  // Field order matches AiSignInView's label map.
  const startUrl = 0;
  const ssoRegion = 1;
  const accountId = 2;
  const roleName = 3;
  const bedrockRegion = 4;
  const modelId = 5;

  Future<void> pumpView(
    WidgetTester tester, {
    AwsSsoConfig? initialConfig,
    void Function(AwsSsoConfig)? onSignIn,
    AwsSsoDeviceAuthorization? pendingAuth,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AiSignInView(
            initialConfig: initialConfig,
            onSignIn: onSignIn ?? (_) {},
            pendingAuth: pendingAuth,
          ),
        ),
      ),
    );
  }

  bool signInEnabled(WidgetTester tester) => tester.widget<FilledButton>(find.byType(FilledButton)).onPressed != null;

  Future<void> fillAll(WidgetTester tester) async {
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(startUrl), 'https://acme.awsapps.com/start/');
    await tester.enterText(fields.at(ssoRegion), 'eu-central-1');
    await tester.enterText(fields.at(accountId), '123456789012');
    await tester.enterText(fields.at(roleName), 'BedrockRole');
    await tester.enterText(fields.at(bedrockRegion), 'eu-central-1');
    await tester.pump();
  }

  testWidgets('cannot sign in until every setting is filled in', (tester) async {
    await pumpView(tester);

    expect(signInEnabled(tester), isFalse);

    await fillAll(tester);

    expect(signInEnabled(tester), isTrue);
  });

  testWidgets('model defaults to a Bedrock model ID', (tester) async {
    await pumpView(tester);

    final field = tester.widget<TextField>(find.byType(TextField).at(modelId));

    expect(field.controller!.text, AwsSsoConfig.defaultModelId);
    // Bedrock requires the provider prefix; a bare Claude ID is rejected.
    expect(AwsSsoConfig.defaultModelId, contains('anthropic.'));
  });

  testWidgets('clearing a required field disables sign-in again', (tester) async {
    await pumpView(tester);
    await fillAll(tester);
    expect(signInEnabled(tester), isTrue);

    await tester.enterText(find.byType(TextField).at(roleName), '   ');
    await tester.pump();

    expect(signInEnabled(tester), isFalse);
  });

  testWidgets('hands back a trimmed config', (tester) async {
    AwsSsoConfig? submitted;
    await pumpView(tester, onSignIn: (c) => submitted = c);

    await fillAll(tester);
    await tester.enterText(find.byType(TextField).at(accountId), '  123456789012  ');
    await tester.pump();

    await tester.ensureVisible(find.byType(FilledButton));
    await tester.tap(find.byType(FilledButton));

    expect(submitted, isNotNull);
    expect(submitted!.accountId, '123456789012');
    expect(submitted!.roleName, 'BedrockRole');
    expect(submitted!.isComplete, isTrue);
  });

  testWidgets('prefills previously saved settings', (tester) async {
    await pumpView(
      tester,
      initialConfig: const AwsSsoConfig(
        startUrl: 'https://saved.awsapps.com/start/',
        ssoRegion: 'eu-west-1',
        accountId: '210987654321',
        roleName: 'SavedRole',
        bedrockRegion: 'eu-west-1',
        modelId: 'eu.anthropic.claude-opus-5',
      ),
    );

    String textAt(int i) => tester.widget<TextField>(find.byType(TextField).at(i)).controller!.text;

    expect(textAt(startUrl), 'https://saved.awsapps.com/start/');
    expect(textAt(accountId), '210987654321');
    expect(textAt(modelId), 'eu.anthropic.claude-opus-5');
    expect(signInEnabled(tester), isTrue);
  });

  testWidgets('while awaiting approval it shows the code instead of the form', (tester) async {
    await pumpView(
      tester,
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

    expect(find.text('ABCD-EFGH'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
