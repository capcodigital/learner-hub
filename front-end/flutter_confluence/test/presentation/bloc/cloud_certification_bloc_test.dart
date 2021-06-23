import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/domain/usecases/get_completed_certification.dart';
import 'package:flutter_confluence/domain/usecases/get_in_progress_certification.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/presentation/bloc/cloud_certification_bloc.dart';
import 'cloud_certification_bloc_test.mocks.dart';

@GenerateMocks([GetCompletedCertification, GetInProgressCertification])
void main() {
  late CloudCertificationBloc bloc;
  late MockGetCompletedCertification mockCompletedCase = MockGetCompletedCertification();
  late MockGetInProgressCertification mockInProgressCase = MockGetInProgressCertification();

  setUp(() {
    bloc = CloudCertificationBloc(
        completedUseCase: mockCompletedCase,
        inProgressUseCase: mockInProgressCase);
  });

  test('initial bloc state should be Empty', () {
    expect(bloc.state, equals(Empty()));
  });

  test(
    'should get list of completed certifications use case',
        () async {
      // arrange
      when(mockCompletedCase.execute(any))
          .thenAnswer((_) async => Right(mockCompletedCerts));
      // act
      bloc.add(GetCompletedCertificationsEvent());
      await untilCalled(mockCompletedCase.execute(any));
      // assert
      verify(mockCompletedCase.execute(NoParams()));
    },
  );

  test(
    'should get list of in progress certifications use case',
        () async {
      // arrange
      when(mockInProgressCase.execute(any))
          .thenAnswer((_) async => Right(mockInrogressCerts));
      // act
      bloc.add(GetInProgressCertificationsEvent());
      await untilCalled(mockInProgressCase.execute(any));
      // assert
      verify(mockInProgressCase.execute(NoParams()));
    },
  );

}
