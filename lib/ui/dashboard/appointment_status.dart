class AppointmentStatus {
  static const String requested = "requested";
  static const String accepted = "accepted";
  static const String onGoing = "on_going";
  static const String cancelled = "canceled";
  static const String completed = "completed";

  static List<String> list() {
    return [requested, accepted, onGoing, cancelled, completed];
  }

}