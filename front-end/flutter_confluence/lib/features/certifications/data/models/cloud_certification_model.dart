import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification.dart';
import 'package:hive/hive.dart';

part 'cloud_certification_model.g.dart';

@HiveType(typeId: 1)
class CloudCertificationModel extends CloudCertification with HiveObjectMixin {
  @override
  @HiveField(0)
  final String name;
  @override
  @HiveField(1)
  final String platform;
  @HiveField(2)
  final String certificationName;
  @HiveField(3)
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'platform': platform,
      'certification': certificationName,
      'date': date,
    };
  }

  @override
  List<Object?> get props => [name, platform, certificationName, date];
}
