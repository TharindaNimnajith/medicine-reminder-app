import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../database/repository.dart';
import '../../models/calendar_day_model.dart';
import '../../models/pill.dart';
import '../../notifications/notifications.dart';
import 'widgets/calendar.dart';
import 'widgets/reminder_list.dart';

class RemindersListScreen extends StatefulWidget {
  @override
  _RemindersListScreenState createState() => _RemindersListScreenState();
}

class _RemindersListScreenState extends State<RemindersListScreen> {
  final Notifications _notifications = Notifications();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final CalendarDayModel _days = CalendarDayModel();
  List<CalendarDayModel> _daysList;

  int _lastChooseDay = 0;

  final Repository _repository = Repository();

  List<Pill> allReminders = <Pill>[];
  List<Pill> dailyReminders = <Pill>[];

  @override
  void initState() {
    super.initState();
    initNotifies();
    setData();
    _daysList = _days.getCurrentDays();
  }

  Future initNotifies() async => flutterLocalNotificationsPlugin =
      await _notifications.initNotifies(context);

  Future setData() async {
    allReminders.clear();
    (await _repository.getAllData('Pills')).forEach((pillMap) {
      allReminders.add(Pill().pillMapToObject(pillMap));
    });
    chooseDay(_daysList[_lastChooseDay]);
  }

  void chooseDay(CalendarDayModel clickedDay) {
    setState(() {
      _lastChooseDay = _daysList.indexOf(clickedDay);
      _daysList.forEach((day) => day.isChecked = false);
      CalendarDayModel chooseDay = _daysList[_daysList.indexOf(clickedDay)];
      chooseDay.isChecked = true;
      dailyReminders.clear();
      allReminders.forEach((reminder) {
        DateTime reminderDate =
            DateTime.fromMicrosecondsSinceEpoch(reminder.time * 1000);
        if (chooseDay.dayNumber == reminderDate.day &&
            chooseDay.month == reminderDate.month &&
            chooseDay.year == reminderDate.year) {
          dailyReminders.add(reminder);
        }
      });
      dailyReminders.sort(
          (reminder1, reminder2) => reminder1.time.compareTo(reminder2.time));
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 3.0,
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            '/add_new_medicine',
          ).then((_) => setData());
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 24.0,
        ),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(
              top: 38.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Column(
              children: [
                Text(
                  'Medicine Reminders'.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'roboto',
                    fontSize: 34.0,
                    color: Colors.blueAccent,
                    letterSpacing: 1.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 40.0,
                    bottom: 18.0,
                  ),
                  child: Calendar(
                    chooseDay,
                    _daysList,
                  ),
                ),
                dailyReminders.isEmpty
                    ? Container(
                        height: deviceHeight * 0.6,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        child: Center(
                          child: EmptyWidget(
                            image: null,
                            packageImage: PackageImage.Image_1,
                            title: 'No Reminders',
                            subTitle: 'No reminders available yet',
                            titleTextStyle: TextStyle(
                              fontFamily: 'roboto',
                              fontSize: 22.0,
                              color: Color(0xff9da9c7),
                              fontWeight: FontWeight.w500,
                            ),
                            subtitleTextStyle: TextStyle(
                              fontFamily: 'roboto',
                              fontSize: 14.0,
                              color: Color(0xffabb8d6),
                            ),
                          ),
                        ),
                      )
                    : ReminderList(
                        dailyReminders,
                        setData,
                        flutterLocalNotificationsPlugin,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
