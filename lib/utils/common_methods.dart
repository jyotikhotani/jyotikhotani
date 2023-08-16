import 'package:intl/intl.dart';

class CommonMethods {
  static String convertDateTimetoMM_dd_yyy(String date) {
    DateTime parseDate =
        DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").parse(date).toLocal();
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd MMM, yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }
}
