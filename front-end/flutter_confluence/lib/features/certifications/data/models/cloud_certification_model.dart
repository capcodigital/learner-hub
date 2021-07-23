import 'package:flutter_confluence/features/certifications/data/models/local_certification.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification.dart';

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
      name: json['name'],
      platform: json['platform'],
      certificationName: json['certification'],
      date: json['date'],
    );

  }

  factory CloudCertificationModel.from(LocalCertification item) {
    return CloudCertificationModel(
      name: item.name,
      platform: item.platform,
      certificationName: item.certificationName,
      date: item.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'platform': this.platform,
      'certification': this.certificationName,
      'date': this.date,
    };
  }

  @override
  List<Object?> get props => [name, platform, certificationName, date];

  static List<CloudCertificationModel> toCloudCertificationModels(
      List<LocalCertification> items) {
    final List<CloudCertificationModel> list = List.empty(growable: true);
    for (LocalCertification item in items) {
      list.add(CloudCertificationModel.from(item));
    }
    return list;
  }
}
