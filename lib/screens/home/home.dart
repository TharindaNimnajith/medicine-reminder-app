import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../database/repository.dart';
import '../../models/calendar_day_model.dart';
import '../../models/pill.dart';
import '../../notifications/notifications.dart';
import '../../screens/home/calendar.dart';
import '../../screens/home/medicines_list.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Notifications _notifications = Notifications();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final Repository _repository = Repository();

  List<Pill> allReminders = <Pill>[];
  List<Pill> dailyReminders = <Pill>[];

  final CalendarDayModel _days = CalendarDayModel();
  List<CalendarDayModel> _daysList;

  int _lastChooseDay = 0;

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

  @override
  Widget build(BuildContext context) {
    final double deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    final Widget addButton = FloatingActionButton(
      elevation: 2.0,
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
      backgroundColor: Theme.of(context).primaryColor,
    );

    return Scaffold(
      floatingActionButton: addButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Color.fromRGBO(248, 248, 248, 1),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(
              top: 40.0,
              bottom: 20.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Column(
              children: [
                Container(
                  child: Text(
                    'Medicine Reminders'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.blueAccent,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 35.0,
                    bottom: 25.0,
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
                              fontSize: 22.0,
                              color: Color(0xff9da9c7),
                              fontWeight: FontWeight.w500,
                            ),
                            subtitleTextStyle: TextStyle(
                              fontSize: 14.0,
                              color: Color(0xffabb8d6),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        child: MedicinesList(
                          dailyReminders,
                          setData,
                          flutterLocalNotificationsPlugin,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void chooseDay(CalendarDayModel clickedDay) {
    setState(() {
      _lastChooseDay = _daysList.indexOf(clickedDay);
      _daysList.forEach((day) => day.isChecked = false);
      CalendarDayModel chooseDay = _daysList[_daysList.indexOf(clickedDay)];
      chooseDay.isChecked = true;
      dailyReminders.clear();
      allReminders.forEach((pill) {
        DateTime pillDate =
            DateTime.fromMicrosecondsSinceEpoch(pill.time * 1000);
        if (chooseDay.dayNumber == pillDate.day &&
            chooseDay.month == pillDate.month &&
            chooseDay.year == pillDate.year) {
          dailyReminders.add(pill);
        }
      });
      dailyReminders.sort((pill1, pill2) => pill1.time.compareTo(pill2.time));
    });
  }
}
