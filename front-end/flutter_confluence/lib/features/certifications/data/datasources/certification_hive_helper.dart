import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';
import 'package:hive/hive.dart';

class CertificationHiveHelper {
  static const BOX_COMPLETED_CERTIFICATIONS = 'completed_certifications';
  static const BOX_IN_PROGRESS_CERTIFICATIONS = 'in_progress_certifications';

  Future<List<CloudCertificationModel>> getCompleted() async {
    return _getCachedCertifications(BOX_COMPLETED_CERTIFICATIONS);
  }

  Future<List<CloudCertificationModel>> getInProgress() async {
    return _getCachedCertifications(BOX_IN_PROGRESS_CERTIFICATIONS);
  }

  Future<List<CloudCertificationModel>> _getCachedCertifications(
      String boxName) async {
    final box = await Hive.openBox<CloudCertificationModel>(boxName);
    final values = box.values.toList().cast<CloudCertificationModel>();
    box.close();
    return values;
  }

  saveCompleted(List<CloudCertificationModel> models) async {
    _save(BOX_COMPLETED_CERTIFICATIONS, models);
  }

  saveInProgress(List<CloudCertificationModel> models) async {
    _save(BOX_IN_PROGRESS_CERTIFICATIONS, models);
  }

  _save(String boxName, List<CloudCertificationModel> models) async {
    final box = await Hive.openBox<CloudCertificationModel>(boxName);
    box.clear();
    // ignore: avoid_function_literals_in_foreach_calls
    models.forEach((model) {
      box.add(model);
    });
    box.close();
  }
}
