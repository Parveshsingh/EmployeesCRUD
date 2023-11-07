import 'package:demoapp/pages/addEditEmployee/addEditEmployeeBloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../common/borders.dart';
import '../../common/commonWidget.dart';
import '../../common/dimens.dart';
import '../../common/text_styles.dart';

class ToCustomDateDialog extends StatefulWidget {
  final AddEditEmployeBloc  bloc;
  const ToCustomDateDialog({super.key, required this.bloc});

  @override
  State<ToCustomDateDialog> createState() => _ToCustomDateDialogState();
}

class _ToCustomDateDialogState extends State<ToCustomDateDialog> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  String customDate = "Today";

  @override
  void initState() {
    super.initState();
    widget.bloc.selectedToDay = DateTime.now();
  }

  void _onSavePressed() {
    Navigator.pop(context,true);
  }

  void _onCancelPressed() {
    Navigator.pop(context,false);
    setState(() {
      widget.bloc.selectedToDay = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.only(
          top: Dimens.dp15,
          bottom: Dimens.dp15,
          left: Dimens.dp15,
          right: Dimens.dp15,
        ),
        color: Colors.white,
        shape: roundedBorder(radius: 10.0, borderColor: Colors.transparent),
        child: ListView(
          padding:const EdgeInsets.fromLTRB(10, 10, 10, 0),
          shrinkWrap: true,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:customDate == "No Date" ? Colors.blue : Colors.blue[50], elevation: 0),
                    onPressed: () {
                      setState(() {
                        customDate = "No Date";
                        widget.bloc.selectedToDay = null;
                      });
                    },
                    child: Text(
                      'No Date',
                      style: semiBoldTextStyle(color: customDate == "No Date" ? Colors.white : Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(
                    width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: customDate == "Today" ? Colors.blue : Colors.blue[50], elevation: 0),
                    onPressed: () {
                      setState(() {
                        widget.bloc.selectedToDay = DateTime.now();
                        customDate = "Today";
                      });

                    },
                    child: Text(
                      'Today',
                      style: semiBoldTextStyle(color: customDate == "Today" ? Colors.white : Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
            TableCalendar(
              firstDay: DateTime(2000),
              lastDay: DateTime(2101),
              focusedDay: widget.bloc.focusedToDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(widget.bloc.selectedToDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  if (selectedDay.day == DateTime.now().day) {
                    customDate = "Today";
                  } else{
                    customDate = "";
                  }
                  widget.bloc.selectedToDay = selectedDay;
                  widget.bloc.focusedToDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                widget.bloc.focusedToDay = focusedDay;
              },
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false, titleCentered: true),
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // Aligns children at the start and end
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.blue,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.bloc.selectedToDay == null
                          ? dateFormatter(widget.bloc.focusedToDay
                          .toLocal()
                          .toString()
                          .split(' ')[0]
                          .toString())
                          : dateFormatter('${widget.bloc.selectedToDay?.toLocal()}'
                          .split(' ')[0]
                          .toString()),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _onCancelPressed,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50], elevation: 0),
                      child: Text(
                        'Cancel',
                        style: semiBoldTextStyle(color: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    ElevatedButton(
                      onPressed: _onSavePressed,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
