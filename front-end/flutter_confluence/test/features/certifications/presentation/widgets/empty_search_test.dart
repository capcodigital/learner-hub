import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification_type.dart';
import 'package:flutter_confluence/features/certifications/presentation/widgets/empty_search.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final TextEditingController controller = TextEditingController();

  testWidgets('EmptySearch shows expected widgets',
      (WidgetTester tester) async {
    // act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptySearch(
            type: CloudCertificationType.completed,
            searchController: controller,
          ),
        ),
      ),
    );

    final txtNoResultsFinder = find.text(EmptySearch.TXT_NO_RESULTS);
    final txtButtonFinder =
        find.byWidgetPredicate((widget) => widget is TextButton);
    final txtClearFinder = find.text(EmptySearch.TXT_CLEAR);

    // assert
    expect(txtNoResultsFinder, findsOneWidget);
    expect(txtButtonFinder, findsOneWidget);
    expect(txtClearFinder, findsOneWidget);
  });
}
