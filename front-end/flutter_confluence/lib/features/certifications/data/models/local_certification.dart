import 'package:hive/hive.dart';

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
}
