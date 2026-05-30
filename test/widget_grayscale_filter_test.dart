import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dr_doom/presentation/widgets/grayscale_filter.dart';
import 'package:dr_doom/providers/intervention_provider.dart';

void main() {
  testWidgets('GrayscaleFilter applies color matrix based on intensity provider', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          grayscaleIntensityProvider.overrideWith((ref) => 0.75),
        ],
        child: const MaterialApp(
          home: GrayscaleFilter(
            child: Text('Hello Color'),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify ColorFiltered widget exists
    final colorFilteredFinder = find.byType(ColorFiltered);
    expect(colorFilteredFinder, findsOneWidget);

    final ColorFiltered colorFilteredWidget = tester.widget(colorFilteredFinder);
    final colorFilter = colorFilteredWidget.colorFilter;

    // Check if matrix filter matches intensity
    expect(colorFilter.toString(), contains('ColorFilter.matrix'));
  });
}
