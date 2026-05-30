import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dr_doom/presentation/widgets/cognitive_bump_overlay.dart';

void main() {
  testWidgets('CognitiveBumpOverlay renders math equation and handles submit', (WidgetTester tester) async {
    // Set larger screen size to ensure all widgets are fully visible and hittestable
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    bool dismissed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CognitiveBumpOverlay(
            onDismiss: () {
              dismissed = true;
            },
          ),
        ),
      ),
    );

    // Verify elements are rendered
    expect(find.text('DOOMSCROLLING TERDETEKSI'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Acak Ulang'), findsOneWidget);
    expect(find.text('Konfirmasi'), findsOneWidget);

    // Verify answer input logic (enter wrong answer first)
    await tester.enterText(find.byType(TextField), '999');
    await tester.ensureVisible(find.text('Konfirmasi'));
    await tester.tap(find.text('Konfirmasi'));
    await tester.pump();

    // Verify warning for wrong answer
    expect(find.text('Jawaban salah, coba latih fokus Anda kembali!'), findsOneWidget);
    expect(dismissed, isFalse);
  });
}
