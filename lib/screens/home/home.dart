import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../database/repository.dart';
import '../../models/pill.dart';
import '../../notifications/notifications.dart';
import '../../screens/home/medicines_list.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Repository _repository = Repository();

  final Notifications _notifications = Notifications();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  List<Pill> pills = <Pill>[];

  @override
  void initState() {
    super.initState();
    initNotifies();
    setData();
  }

  Future initNotifies() async => flutterLocalNotificationsPlugin =
      await _notifications.initNotifies(context);

  Future setData() async {
    pills.clear();
    (await _repository.getAllData('Pills')).forEach((pillMap) {
      pills.add(Pill().pillMapToObject(pillMap));
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    final Widget addButton = FloatingActionButton(
      elevation: 2.0,
      onPressed: () async {
        await Navigator.pushNamed(context, '/add_new_medicine')
            .then((_) => setData());
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
          child: Padding(
            padding: EdgeInsets.only(
              top: 0.0,
              left: 25.0,
              right: 25.0,
              bottom: 20.0,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: deviceHeight * 0.04,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  child: Text(
                    'Medicine Reminder',
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                ),
                pills.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 10.0,
                        ),
                        child: EmptyWidget(
                          image: null,
                          packageImage: PackageImage.Image_1,
                          title: 'No Reminders',
                          subTitle: 'No reminders available yet',
                          titleTextStyle: TextStyle(
                            fontSize: 22,
                            color: Color(0xff9da9c7),
                            fontWeight: FontWeight.w500,
                          ),
                          subtitleTextStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xffabb8d6),
                          ),
                        ),
                      )
                    : MedicinesList(
                        pills,
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
