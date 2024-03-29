import 'package:flutter/material.dart';

import '../../../models/calendar_day_model.dart';
import 'calendar_day.dart';

class Calendar extends StatefulWidget {
  final Function chooseDay;
  final List<CalendarDayModel> _daysList;

  Calendar(
    this.chooseDay,
    this._daysList,
  );

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    final double deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Container(
      height: deviceHeight * 0.11,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...widget._daysList.map(
            (day) => CalendarDay(
              day,
              widget.chooseDay,
            ),
          ),
        ],
      ),
    );
  }
}
