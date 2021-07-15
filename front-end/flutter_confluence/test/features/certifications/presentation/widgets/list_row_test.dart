import 'package:flutter/material.dart';
import 'package:flutter_confluence/features/certifications/presentation/widgets/list_row.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/FixtureReader.dart';

void main() {
  final mockCert = getMockCompletedCertifications()[0];

  testWidgets('ListRow shows expected widgets', (WidgetTester tester) async {
    // act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListRow(
            item: mockCert,
          ),
        ),
      ),
    );

    final cardFinder = find.byWidgetPredicate((widget) => widget is Card);
    final circleAvatarFinder = find.byWidgetPredicate((widget) => widget is CircleAvatar);
    final txtNameFinder = find.text(mockCert.name);
    final txtCertNameFinder = find.text(mockCert.certificationName);
    final txtDateFinder = find.text(mockCert.certificationDate);
    final txtCertTypeFinder = find.text(mockCert.certificationType);
    
    // assert
    expect(cardFinder, findsOneWidget);
    expect(circleAvatarFinder, findsOneWidget);
    expect(txtNameFinder, findsOneWidget);
    expect(txtCertNameFinder, findsOneWidget);
    expect(txtDateFinder, findsOneWidget);
    expect(txtCertTypeFinder, findsOneWidget);
  });
}
