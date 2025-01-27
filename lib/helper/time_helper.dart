// We will align everything to minutes

abstract final class TimeHelper {
  static String formatSeconds(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds ~/ 60) % 60;
    final s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  static String formatMinutes(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }
}
