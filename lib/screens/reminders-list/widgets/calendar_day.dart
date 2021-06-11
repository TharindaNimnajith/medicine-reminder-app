import 'package:flutter/material.dart';

import '../../../models/calendar_day_model.dart';

class CalendarDay extends StatefulWidget {
  final CalendarDayModel day;
  final Function onDayClick;

  CalendarDay(
    this.day,
    this.onDayClick,
  );

  @override
  _CalendarDayState createState() => _CalendarDayState();
}

// references: https://stackoverflow.com/questions/61755268/how-to-create-custom-calendar-in-flutter
// references: https://stackoverflow.com/questions/58229684/how-to-achieve-singleline-horizontal-calendarview-in-flutter
// references: https://medium.com/flutterdevs/display-dynamic-events-at-calendar-in-flutter-22b69b29daf6
class _CalendarDayState extends State<CalendarDay> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => widget.onDayClick(widget.day),
            child: CircleAvatar(
              radius: constrains.maxHeight * 0.25,
              backgroundColor: widget.day.isChecked
                  ? Colors.blueAccent
                  : Color.fromRGBO(193, 247, 255, 0.4),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  widget.day.dayNumber.toString(),
                  style: TextStyle(
                    fontFamily: 'roboto',
                    color:
                        widget.day.isChecked ? Colors.white : Colors.blueAccent,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: constrains.maxHeight * 0.1,
          ),
          Text(
            widget.day.dayLetter,
            style: TextStyle(
              color: Colors.grey[500],
              fontFamily: 'roboto',
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
