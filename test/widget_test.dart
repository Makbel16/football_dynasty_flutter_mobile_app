import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football_dynasty/app.dart';

void main() {
  testWidgets('App loads splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: FootballDynastyApp()),
    );
    await tester.pump();
    expect(find.text('Football Dynasty'), findsOneWidget);
  });
}
