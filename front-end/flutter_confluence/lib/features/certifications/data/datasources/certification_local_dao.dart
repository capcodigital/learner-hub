import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';
import 'package:hive/hive.dart';

class CertificationLocalDao {
  static const COMPLETED_CERTIFICATIONS = 'completed_certifications';
  static const IN_PROGRESS_CERTIFICATIONS = 'in_progress_certifications';

  static Box<CloudCertificationModel> getBox(String boxName) =>
      Hive.box<CloudCertificationModel>(boxName);

  static Box<CloudCertificationModel> getBoxCompleted() =>
      getBox(COMPLETED_CERTIFICATIONS);

  static Box<CloudCertificationModel> getBoxInProgress() =>
      getBox(IN_PROGRESS_CERTIFICATIONS);

  List<CloudCertificationModel> getCompleted() {
    return getBoxCompleted().values.toList().cast<CloudCertificationModel>();
  }

  List<CloudCertificationModel> getInProgress() {
    return getBoxInProgress().values.toList().cast<CloudCertificationModel>();
  }

  saveCompleted(List<CloudCertificationModel> models) {
    Box<CloudCertificationModel> box = getBoxCompleted();
    box.clear();
    for (CloudCertificationModel model in models) {
      box.add(model);
    }
    print("saveCompleted: " + models.join(", "));
  }

  saveInProgress(List<CloudCertificationModel> models) {
    Box<CloudCertificationModel> box = getBoxInProgress();
    box.clear();
    for (CloudCertificationModel model in models) {
      box.add(model);
    }
    print("saveInProgress: " + models.join(", "));
  }
}
