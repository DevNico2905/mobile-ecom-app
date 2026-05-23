// Smoke test: la app arranca y muestra la pantalla de login.

import 'package:flutter_test/flutter_test.dart';

import 'package:project/app.dart';

void main() {
  testWidgets('App muestra pantalla de login', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Inicia sesión'), findsOneWidget);
  });
}
