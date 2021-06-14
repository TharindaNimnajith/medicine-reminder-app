import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import '../../../database/repository.dart';
import '../../../models/pill.dart';
import '../../../notifications/notifications.dart';

class ReminderListItem extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final Pill reminder;
  final Function setData;

  ReminderListItem(
    this.reminder,
    this.setData,
    this.flutterLocalNotificationsPlugin,
  );

  void _showDeleteDialog(
    BuildContext context,
    String medicineName,
    int medicineId,
    int notifyId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete?',
        ),
        content: Text(
          'Are you sure to delete $medicineName medicine?',
        ),
        contentTextStyle: TextStyle(
          fontSize: 17.0,
          color: Colors.grey[800],
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Delete',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onPressed: () async {
              await Repository().deleteData(
                'Pills',
                medicineId,
              );
              await Notifications().removeNotify(
                notifyId,
                flutterLocalNotificationsPlugin,
              );
              setData();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnd = DateTime.now().millisecondsSinceEpoch > reminder.time;

    return Card(
      elevation: 7.0,
      margin: EdgeInsets.symmetric(
        vertical: 7.0,
      ),
      child: ListTile(
        onTap: () => Navigator.pushNamed(context, "/edit_medicine",
            arguments: reminder.id),
        onLongPress: () => _showDeleteDialog(
          context,
          reminder.name,
          reminder.id,
          reminder.notifyId,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 15.0,
        ),
        leading: Container(
          width: 60.0,
          height: 60.0,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                isEnd ? Colors.white : Colors.transparent,
                BlendMode.saturation,
              ),
              child: Image.asset(
                reminder.image,
              ),
            ),
          ),
        ),
        title: Text(
          reminder.name,
          style: Theme.of(context).textTheme.headline1.copyWith(
                fontFamily: 'roboto',
                color: Colors.black,
                fontSize: 20.0,
                decoration: isEnd ? TextDecoration.lineThrough : null,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${reminder.amount} ${reminder.type}',
          style: Theme.of(context).textTheme.headline5.copyWith(
                fontFamily: 'roboto',
                color: Colors.grey[600],
                fontSize: 15.0,
                decoration: isEnd ? TextDecoration.lineThrough : null,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat('HH:mm').format(
                DateTime.fromMillisecondsSinceEpoch(
                  reminder.time,
                ),
              ),
              style: TextStyle(
                fontFamily: 'roboto',
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
                fontSize: 15,
                decoration: isEnd ? TextDecoration.lineThrough : null,
              ),
            ),
            Text(
              '${reminder.howManyWeeks} weeks',
              style: TextStyle(
                fontFamily: 'roboto',
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
                fontSize: 15,
                decoration: isEnd ? TextDecoration.lineThrough : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
