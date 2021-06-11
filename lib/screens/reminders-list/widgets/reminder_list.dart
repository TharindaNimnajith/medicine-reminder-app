import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../models/pill.dart';
import 'reminder_list_item.dart';

class ReminderList extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final List<Pill> reminders;
  final Function setData;

  ReminderList(
    this.reminders,
    this.setData,
    this.flutterLocalNotificationsPlugin,
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => ReminderListItem(
        reminders[index],
        setData,
        flutterLocalNotificationsPlugin,
      ),
      itemCount: reminders.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }
}
