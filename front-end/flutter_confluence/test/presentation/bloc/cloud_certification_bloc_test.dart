import 'package:flutter_confluence/domain/usecases/get_completed_certifications.dart';
import 'package:flutter_confluence/domain/usecases/get_in_progress_certifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_confluence/presentation/bloc/cloud_certification_bloc.dart';

class MockGetCompleted extends Mock implements GetCompletedCertifications {}

class MockGetInProgress extends Mock implements GetInProgressCertifications {}

void main() {
  late MockGetCompleted mockCompletedCase = MockGetCompleted();
  late MockGetInProgress mockInProgressCase = MockGetInProgress();
  late CloudCertificationBloc bloc;

  setUp(() {
    mockCompletedCase = MockGetCompleted();
    mockInProgressCase = MockGetInProgress();
    bloc = CloudCertificationBloc(
        completedUseCase: mockCompletedCase,
        inProgressUseCase: mockInProgressCase);
  });

  test('initialState should be Empty', () {
    expect(bloc.initialState, equals(Empty()));
  });
}
