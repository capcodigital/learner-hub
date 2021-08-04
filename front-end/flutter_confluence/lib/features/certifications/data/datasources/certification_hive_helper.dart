import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';
import 'package:hive/hive.dart';

class CertificationHiveHelper {
  static const BOX_COMPLETED_CERTIFICATIONS = 'completed_certifications';
  static const BOX_IN_PROGRESS_CERTIFICATIONS = 'in_progress_certifications';

  Future<List<CloudCertificationModel>> getCompleted() async {
    return getCachedCertifications(BOX_COMPLETED_CERTIFICATIONS);
  }

  Future<List<CloudCertificationModel>> getInProgress() async {
    return getCachedCertifications(BOX_IN_PROGRESS_CERTIFICATIONS);
  }

  Future<List<CloudCertificationModel>> getCachedCertifications(
      String boxName) async {
    final box = await Hive.openBox<CloudCertificationModel>(boxName);
    final values = box.values.toList().cast<CloudCertificationModel>();
    box.close();
    return values;
  }

  saveCompleted(List<CloudCertificationModel> models) async {
    save(BOX_COMPLETED_CERTIFICATIONS, models);
  }

  saveInProgress(List<CloudCertificationModel> models) async {
    save(BOX_IN_PROGRESS_CERTIFICATIONS, models);
  }

  save(String boxName, List<CloudCertificationModel> models) async {
    final box = await Hive.openBox<CloudCertificationModel>(boxName);
    box.clear();
    for (CloudCertificationModel model in models) {
      box.add(model);
    }
    box.close();
  }
}
