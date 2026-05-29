import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dr_doom/presentation/widgets/cognitive_bump_overlay.dart';

void main() {
  testWidgets('CognitiveBumpOverlay renders math equation and handles submit', (WidgetTester tester) async {
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
    await tester.tap(find.text('Konfirmasi'));
    await tester.pump();

    // Verify warning for wrong answer
    expect(find.text('Jawaban salah, coba latih fokus Anda kembali!'), findsOneWidget);
    expect(dismissed, isFalse);
  });
}
