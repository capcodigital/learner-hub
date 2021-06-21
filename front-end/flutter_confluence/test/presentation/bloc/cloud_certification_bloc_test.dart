import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_confluence/domain/usecases/get_cloud_certifications.dart';
import 'package:flutter_confluence/presentation/bloc/cloud_certification_bloc.dart';

class MockGetCloudCertifications extends Mock
    implements GetCloudCertifications {}

void main() {
  late MockGetCloudCertifications mockUseCase = MockGetCloudCertifications();
  late CloudCertificationBloc bloc;

  setUp(() {
    mockUseCase = MockGetCloudCertifications();
    bloc = CloudCertificationBloc(getCloudCertifications: mockUseCase);
  });

  test('initialState should be Empty', () {
    expect(bloc.initialState, equals(Empty()));
  });
}
