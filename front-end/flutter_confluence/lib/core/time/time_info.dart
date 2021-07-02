abstract class TimeInfo {
  int get currentTimeMillis;
}

class TimeInfoImpl implements TimeInfo {

  @override
  int get currentTimeMillis {
    return DateTime.now().millisecond;
  }
}
