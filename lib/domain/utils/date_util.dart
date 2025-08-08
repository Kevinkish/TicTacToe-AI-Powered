class DateUtil {
  static String dateFormatter(
    DateTime date, {
    bool withDay = false,
    bool withTime = false,
  }) {
    int wd = date.weekday;
    String day = "";
    switch (wd) {
      case 1:
        day = "Monday";
      case 2:
        day = "Tuesday";
      case 3:
        day = "Wednesday";
      case 4:
        day = "Thursday";
      case 5:
        day = "Friday";
      case 6:
        day = "Saturday";
      case 7:
        day = "Sunday";
        break;
      default:
        day = "Monday";
    }
    String dd = date.day.toString().padLeft(2, "0");
    String mm = date.month.toString().padLeft(2, "0");
    String yyyy = date.year.toString();
    String time =
        "${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}";
    return "${withDay ? "$day " : ""}$dd/$mm/$yyyy${withTime ? " $time" : ""}";
  }
}
