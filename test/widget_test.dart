import 'package:flutter_test/flutter_test.dart';

import 'package:relax_breathing/main.dart';

void main() {
  testWidgets('App loads and shows breathing screen', (WidgetTester tester) async {
    await tester.pumpWidget(const RelaxApp());

    expect(find.text('Respiration Profonde'), findsOneWidget);
    expect(find.text('Démarrer'), findsOneWidget);
  });
}
