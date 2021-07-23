import 'package:hive/hive.dart';

class BioAuthLocalDao {
  static const BOX_BIO_AUTH_TIME = 'bio_auth_time';
  static const LATEST_BIO_AUTH_TIME_MILLIS = 'latest_bio_auth_time_millis';

  static Box<int?> getBoxBioAuthTime() => Hive.box<int?>(BOX_BIO_AUTH_TIME);

  int? getLatestBioAuthTime() {
    return getBoxBioAuthTime().get(LATEST_BIO_AUTH_TIME_MILLIS);
  }

  saveLatestBioAuthTime(int latestBioAuthTime) {
    Box<int?> box = getBoxBioAuthTime();
    box.put(LATEST_BIO_AUTH_TIME_MILLIS, latestBioAuthTime);
  }
}
