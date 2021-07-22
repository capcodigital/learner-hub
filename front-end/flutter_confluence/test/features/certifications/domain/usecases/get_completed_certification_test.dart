import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification.dart';
import 'package:flutter_confluence/features/certifications/domain/repositories/cloud_certification_repository.dart';
import 'package:flutter_confluence/features/certifications/domain/usecases/get_completed_certifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCloudCertificationRepository extends Mock
    implements CloudCertificationRepository {}

void main() {
  late GetCompletedCertifications usecase;
  late MockCloudCertificationRepository mockCloudCertificationRepository;

  setUp(() {
    mockCloudCertificationRepository = MockCloudCertificationRepository();
    usecase = GetCompletedCertifications(mockCloudCertificationRepository);
  });

  final tCloudCertification = [
    CloudCertification(
        name: 'Joshua',
        platform: 'GCP',
        certificationType: 'Azure',
        certificationDate: '2021/05/26')
  ];

  test('should get completed cloud certifications from the repository',
      () async {
    // arrange
    when(() => mockCloudCertificationRepository.getCompletedCertifications())
        .thenAnswer((_) async => Right(tCloudCertification));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, Right(tCloudCertification));
    verify(() => mockCloudCertificationRepository.getCompletedCertifications());
    verifyNoMoreInteractions(mockCloudCertificationRepository);
  });
}
