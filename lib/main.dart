import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicine/screens/edit_medicine/edit_medicine.dart';

import './screens/welcome/welcome.dart';
import 'screens/add_new_medicine/add_new_medicine.dart';
import 'screens/reminders-list/reminders_list_screen.dart';
// import '../../screens/add_new_medicine/add_new_medicine.dart';
// import '../../screens/reminders-list/reminders_list_screen.dart';

void main() {
  runApp(MedicineApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black.withOpacity(0.05),
      statusBarColor: Colors.black.withOpacity(0.05),
      statusBarIconBrightness: Brightness.dark));
}

class MedicineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: "Popins",
          primaryColor: Colors.blueAccent,
          textTheme: TextTheme(
              headline1: ThemeData.light().textTheme.headline1.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 38.0,
                    fontFamily: "Popins",
                  ),
              headline5: ThemeData.light().textTheme.headline1.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 17.0,
                    fontFamily: "Popins",
                  ),
              headline3: ThemeData.light().textTheme.headline3.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                    fontFamily: "Popins",
                  ))),
      routes: {
        "/": (context) => Welcome(),
        "/home": (context) => RemindersListScreen(),
        "/add_new_medicine": (context) => AddNewMedicine(),
        "/edit_medicine": (context) => EditMedicine(),
      },
      initialRoute: "/",
    );
  }
}
