import 'package:flutter_confluence/domain/entities/cloud_certification.dart';

class CloudCertificationModel extends CloudCertification {
  final String name;
  final String platform;
  final String certificationName;
  final String date;

  CloudCertificationModel({
    required this.name,
    required this.platform,
    required this.certificationName,
    required this.date,
  }) : super(
            name: name,
            platform: platform,
            certificationType: certificationName,
            certificationDate: date);

  factory CloudCertificationModel.fromJson(Map<String, dynamic> json) {
    return CloudCertificationModel(
      name: json['Name'],
      platform: json['Platform'],
      certificationName: json['Certification'],
      date: json['Date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': this.name,
      'Platform': this.platform,
      'Certification': this.certificationName,
      'Date': this.date,
    };
  }

  @override
  List<Object?> get props => [name, platform, certificationName, date];
}
