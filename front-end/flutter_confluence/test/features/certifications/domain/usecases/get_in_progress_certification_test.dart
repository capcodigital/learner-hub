import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification.dart';
import 'package:flutter_confluence/features/certifications/domain/repositories/cloud_certification_repository.dart';
import 'package:flutter_confluence/features/certifications/domain/usecases/get_in_progress_certifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCloudCertificationRepository extends Mock
    implements CloudCertificationRepository {}

void main() {
  late GetInProgressCertifications usecase;
  late MockCloudCertificationRepository mockCloudCertificationRepository;

  setUp(() {
    mockCloudCertificationRepository = MockCloudCertificationRepository();
    usecase = GetInProgressCertifications(mockCloudCertificationRepository);
  });

  final tCloudCertification = [
    CloudCertification(
        name: 'Jason',
        platform: 'GCP',
        certificationType: 'Azure',
        certificationDate: '2022/01/25')
  ];

  test('should get in-progress cloud certifications from the repository',
      () async {
    // arrange
    when(() => mockCloudCertificationRepository.getInProgressCertifications())
        .thenAnswer((_) async => Right(tCloudCertification));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, Right(tCloudCertification));
    verify(() => mockCloudCertificationRepository.getInProgressCertifications());
    verifyNoMoreInteractions(mockCloudCertificationRepository);
  });
}
