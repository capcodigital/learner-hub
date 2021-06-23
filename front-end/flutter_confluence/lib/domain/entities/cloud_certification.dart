import 'package:equatable/equatable.dart';

import '../../core/constants.dart';

class CloudCertification extends Equatable{
  final String name;
  final String platform;
  final String certificationType;
  final String certificationDate;
  String? certificationIconName;

  CloudCertification(
      {required this.name,
      required this.platform,
      required this.certificationType,
      required this.certificationDate}){
    setCertificationIconName();
  }

    String get icon {
    switch (this.certificationType) {
      case Constants.GCP:
        return Constants.IC_GCP;
      case Constants.AZURE:
        return Constants.IC_AZURE;
      case Constants.CLOUD_NATIVE:
        return Constants.IC_CLOUD_NATIVE;
      case Constants.HASHICORP:
        return Constants.IC_HASHICORP;
      case Constants.AWS:
        return Constants.IC_AWS;
    }
  }

  @override
  List<Object?> get props => [name, platform, certificationType, certificationType, certificationIconName];
}
