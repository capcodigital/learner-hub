import 'package:hive/hive.dart';

import 'cloud_certification_model.dart';

part 'local_certification.g.dart';

@HiveType(typeId: 0)
class LocalCertification extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  late String platform;
  @HiveField(2)
  late String certificationName;
  @HiveField(3)
  late String date;

  static LocalCertification from(
      CloudCertificationModel model) {
    return LocalCertification()
      ..name = model.name
      ..platform = model.platform
      ..certificationName = model.certificationName
      ..date = model.date;
  }

  static List<LocalCertification> getLocalCertifications(
      Box<LocalCertification> box) {
    return box.values.toList().cast<LocalCertification>();
  }
}
