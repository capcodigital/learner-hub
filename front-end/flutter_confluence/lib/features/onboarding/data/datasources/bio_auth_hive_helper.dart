import 'package:hive/hive.dart';

class BioAuthHiveHelper {
  static const BOX_BIO_AUTH_TIME = 'bio_auth_time';
  static const LATEST_BIO_AUTH_TIME_MILLIS = 'latest_bio_auth_time_millis';

  Future<int?> getLatestBioAuthTime() async {
    final box = await Hive.openBox<int?>(BOX_BIO_AUTH_TIME);
    final value = box.get(LATEST_BIO_AUTH_TIME_MILLIS);
    box.close();
    return value;
  }

  save(int? timeMillis) async {
    final box = await Hive.openBox<int?>(BOX_BIO_AUTH_TIME);
    box.clear();
    box.put(LATEST_BIO_AUTH_TIME_MILLIS, timeMillis);
    box.close();
  }
}
