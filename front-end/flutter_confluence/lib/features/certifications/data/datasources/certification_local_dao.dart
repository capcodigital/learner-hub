import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';
import 'package:flutter_confluence/features/certifications/data/models/local_certification.dart';
import 'package:hive/hive.dart';

class CertificationLocalDao {
  static const COMPLETED_CERTIFICATIONS = 'completed_certifications';
  static const IN_PROGRESS_CERTIFICATIONS = 'in_progress_certifications';

  List<CloudCertificationModel> getCompleted() {
    final items = getLocalCertifications(getBoxCompleted());
    return toCloudCertificationModels(items);
  }

  List<CloudCertificationModel> getInProgress() {
    final items = getLocalCertifications(getBoxInProgress());
    return toCloudCertificationModels(items);
  }

  saveCompleted(List<CloudCertificationModel> models) {
    Box<LocalCertification> box = getBoxCompleted();
    box.clear();
    for (CloudCertificationModel model in models) {
      final local = toLocalCertification(model);
      box.add(local);
    }
  }

  saveInProgress(List<CloudCertificationModel> models) {
    Box<LocalCertification> box = getBoxInProgress();
    box.clear();
    for (CloudCertificationModel model in models) {
      box.add(toLocalCertification(model));
    }
  }

  static Box<LocalCertification> getBoxCompleted() =>
      Hive.box<LocalCertification>(COMPLETED_CERTIFICATIONS);

  static Box<LocalCertification> getBoxInProgress() =>
      Hive.box<LocalCertification>(IN_PROGRESS_CERTIFICATIONS);

  static List<LocalCertification> getLocalCertifications(
      Box<LocalCertification> box) {
    return box.values.toList().cast<LocalCertification>();
  }

  static List<CloudCertificationModel> toCloudCertificationModels(
      List<LocalCertification> items) {
    final List<CloudCertificationModel> list = List.empty(growable: true);
    for (LocalCertification item in items) {
      list.add(toCloudCertificationModel(item));
    }
    return list;
  }

  static CloudCertificationModel toCloudCertificationModel(
      LocalCertification item) {
    return CloudCertificationModel(
        name: item.name,
        platform: item.platform,
        certificationName: item.certificationName,
        date: item.date);
  }

  static LocalCertification toLocalCertification(
      CloudCertificationModel model) {
    return LocalCertification()
      ..name = model.name
      ..platform = model.platform
      ..certificationName = model.certificationName
      ..date = model.date;
  }
}
