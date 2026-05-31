import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dr_doom/presentation/screens/onboarding/onboarding_screen.dart';

void main() {
  testWidgets('OnboardingScreen PageView swiping and content smoke test', (WidgetTester tester) async {
    // Build the OnboardingScreen widget wrapped in ProviderScope
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: OnboardingScreen(),
        ),
      ),
    );

    // 1. Verify Welcome Screen (Page 1) renders correctly
    expect(find.text('Selamat Datang di\ndr_doom'), findsOneWidget);
    expect(
      find.text('Taklukkan kebiasaan doomscrolling dan kembalikan fokus Anda.'),
      findsOneWidget,
    );
    expect(find.text('Selanjutnya'), findsOneWidget);

    // 2. Tap 'Selanjutnya' button to animate to Page 2
    await tester.tap(find.text('Selanjutnya'));
    await tester.pumpAndSettle();

    // 3. Verify Accessibility Disclosure (Page 2)
    expect(find.text('Deteksi Gulir Layar'), findsOneWidget);
    expect(find.text('Berikan Izin Aksesibilitas'), findsOneWidget);
  });
}
