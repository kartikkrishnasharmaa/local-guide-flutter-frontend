import 'package:intl/intl.dart';

class TimeUtils {
  static const String ddMMMyyyy = "dd MMM yyyy";
  static const String dd_MM_yyyy_SLASHED = "dd/MM/yyyy";
  static const String MMM_dd_yyyy_hh_mm_a = "MMM dd, yyyy hh:mm a";
  static const String dd_MM_yyyy = "dd-MM-yyyy";
  static const String yyyyMMdd = "yyyy-MM-dd";
  static const String FORMAT_YYYY_MM_dd_HH_mm_ss_SSS_Z = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
  static const String yyyyMMddhhMMa = "yyyy-MM-dd hh:mm a";
  static const String hhmma = "hh:mm a";
  static const String HHmmss = "HH:mm:ss";

  static String currentDate({String? format}) {
    return DateFormat(format ?? yyyyMMdd).format(DateTime.now());
  }

  static String format(DateTime? dateTime, {String? format}) {
    return dateTime == null ? "" : DateFormat(format ?? yyyyMMdd).format(dateTime);
  }

  static DateTime parseUtcToLocal(string) {
    var result = DateTime.now();
    try {
      result = DateTime.parse(string);
    } catch (e) {
      print(e);
    }
    return result.toLocal();
  }

  static DateTime parse(string, {String? format}) {
    var result = DateTime.now();
    try {
      result = DateFormat(format ?? ddMMMyyyy).parse(string);
    } catch (e) {
      print(e);
    }
    return result;
  }
}
