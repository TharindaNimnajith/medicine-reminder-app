import 'package:intl/intl.dart';

class CalendarDayModel {
  String dayLetter;
  int dayNumber;
  int month;
  int year;
  bool isChecked;

  CalendarDayModel({
    this.dayLetter,
    this.dayNumber,
    this.year,
    this.month,
    this.isChecked,
  });

  // references: https://stackoverflow.com/questions/65592085/scroll-through-current-and-previous-week-using-controller-in-horizontal-calendar
  List<CalendarDayModel> getCurrentDays() {
    final List<CalendarDayModel> daysList = [];
    DateTime currentTime = DateTime.now();
    for (int i = 0; i < 7; i++) {
      daysList.add(CalendarDayModel(
        dayLetter: DateFormat.E().format(currentTime).toString(),
        dayNumber: currentTime.day,
        month: currentTime.month,
        year: currentTime.year,
        isChecked: false,
      ));
      currentTime = currentTime.add(Duration(
        days: 1,
      ));
    }
    daysList[0].isChecked = true;
    return daysList;
  }
}
