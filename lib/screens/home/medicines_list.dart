import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../models/pill.dart';
import '../../screens/home/medicine_card.dart';

class MedicinesList extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final List<Pill> reminders;
  final Function setData;

  MedicinesList(
    this.reminders,
    this.setData,
    this.flutterLocalNotificationsPlugin,
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => MedicineCard(
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
