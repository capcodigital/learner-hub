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

  void setCertificationIconName() {
    switch (this.certificationType) {
      case Constants.GCP:
        certificationIconName = Constants.IC_GCP;
        break;
      case Constants.AZURE:
        certificationIconName = Constants.IC_AZURE;
        break;
      case Constants.CLOUD_NATIVE:
        certificationIconName = Constants.IC_CLOUD_NATIVE;
        break;
      case Constants.HASHICORP:
        certificationIconName = Constants.IC_HASHICORP;
        break;
      case Constants.AWS:
        certificationIconName = Constants.IC_AWS;

    }
  }

  @override
  List<Object?> get props => [name, platform, certificationType, certificationType, certificationIconName];
}