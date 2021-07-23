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

  Future<List<CloudCertificationModel>> getCompleted() async {
    final box = await Hive.openBox<CloudCertificationModel>(
        CertificationLocalDao.COMPLETED_CERTIFICATIONS);
    final values =
        getBoxCompleted().values.toList().cast<CloudCertificationModel>();
    box.close();
    return values;
  }

  Future<List<CloudCertificationModel>> getInProgress() async {
    final box = await Hive.openBox<CloudCertificationModel>(
        CertificationLocalDao.IN_PROGRESS_CERTIFICATIONS);
    final values =
        getBoxInProgress().values.toList().cast<CloudCertificationModel>();
    box.close();
    return values;
  }

  saveCompleted(List<CloudCertificationModel> models) async {
    final box = await Hive.openBox<CloudCertificationModel>(
        CertificationLocalDao.COMPLETED_CERTIFICATIONS);
    box.clear();
    for (CloudCertificationModel model in models) {
      box.add(model);
    }
    box.close();
    print("saveCompleted: " + models.join(", "));
  }

  saveInProgress(List<CloudCertificationModel> models) async {
    final box = await Hive.openBox<CloudCertificationModel>(
        CertificationLocalDao.IN_PROGRESS_CERTIFICATIONS);
    box.clear();
    for (CloudCertificationModel model in models) {
      box.add(model);
    }
    box.close();
    print("saveInProgress: " + models.join(", "));
  }
}
