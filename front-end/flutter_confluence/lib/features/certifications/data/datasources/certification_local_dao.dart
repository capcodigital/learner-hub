import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';
import 'package:flutter_confluence/features/certifications/data/models/local_certification.dart';
import 'package:hive/hive.dart';

class CertificationLocalDao {
  static const COMPLETED_CERTIFICATIONS = 'completed_certifications';
  static const IN_PROGRESS_CERTIFICATIONS = 'in_progress_certifications';

  static Box<LocalCertification> getBox(String boxName) =>
      Hive.box<LocalCertification>(boxName);

  static Box<LocalCertification> getBoxCompleted() =>
      getBox(COMPLETED_CERTIFICATIONS);

  static Box<LocalCertification> getBoxInProgress() =>
      getBox(IN_PROGRESS_CERTIFICATIONS);

  List<CloudCertificationModel> getCompleted() {
    final items = getBoxCompleted().values.toList().cast<LocalCertification>();
    return CloudCertificationModel.toCloudCertificationModels(items);
  }

  List<CloudCertificationModel> getInProgress() {
    final items = getBoxInProgress().values.toList().cast<LocalCertification>();
    return CloudCertificationModel.toCloudCertificationModels(items);
  }

  saveCompleted(List<CloudCertificationModel> models) {
    Box<LocalCertification> box = getBoxCompleted();
    box.clear();
    for (CloudCertificationModel model in models) {
      final local = LocalCertification.from(model);
      box.add(local);
    }
  }

  saveInProgress(List<CloudCertificationModel> models) {
    Box<LocalCertification> box = getBoxInProgress();
    box.clear();
    for (CloudCertificationModel model in models) {
      box.add(LocalCertification.from(model));
    }
  }
}
