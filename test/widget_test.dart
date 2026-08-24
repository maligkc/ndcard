import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ndcard/app/config_missing_app.dart';
import 'package:ndcard/l10n/gen/app_localizations.dart';

void main() {
  testWidgets('ConfigMissingApp shows configuration warning', (WidgetTester tester) async {
    await tester.pumpWidget(const ConfigMissingApp());
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('tr'));
    expect(find.text(l10n.configMissingTitle), findsOneWidget);
  });
}
