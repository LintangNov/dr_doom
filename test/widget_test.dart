import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dr_doom/main.dart';

void main() {
  testWidgets('App starts and loads OnboardingScreen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Wait for the GoRouter navigation and layouts to settle
    await tester.pumpAndSettle();

    // Verify that the Onboarding page contents are loaded
    expect(find.text('dr_doom'), findsOneWidget);
    expect(
      find.text('Taklukkan kebiasaan doomscrolling dan kembalikan fokus Anda.'),
      findsOneWidget,
    );
    expect(find.text('Selanjutnya'), findsOneWidget);
  });
}
