import 'package:demoapp/pages/addEditEmployee/addEditEmployeeBloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../common/borders.dart';
import '../../common/commonWidget.dart';
import '../../common/dimens.dart';
import '../../common/text_styles.dart';

class FromDateDialog extends StatefulWidget {
  final AddEditEmployeBloc bloc;

  const FromDateDialog({super.key, required this.bloc});

  @override
  State<FromDateDialog> createState() => _FromDateDialogState();
}

class _FromDateDialogState extends State<FromDateDialog> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  String customDate = "Today";

  @override
  void initState() {
    super.initState();
    widget.bloc.selectedFromDay = DateTime.now();
  }

  void _onSavePressed() {
    Navigator.pop(context, true);
  }

  void _onCancelPressed() {
    Navigator.pop(context, false);
    setState(() {
      widget.bloc.selectedFromDay = null;
    });
  }

  calculateNextMonday() {
    DateTime currentDate = DateTime.now();
    if (currentDate.weekday == DateTime.monday) {
      currentDate = currentDate.add(const Duration(days: 7));
    } else {
      while (currentDate.weekday != DateTime.monday) {
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }

    setState(() {
      widget.bloc.selectedFromDay = currentDate;
    });
  }

  calculateNextTuesday() {
    DateTime currentDate = DateTime(2023,11,8);

    int daysUntilNextTuesday = (DateTime.tuesday - currentDate.weekday + 7) % 7;

    DateTime nextTuesday = currentDate.add(Duration(days: daysUntilNextTuesday));

    if (currentDate.weekday == DateTime.tuesday) {
      nextTuesday = nextTuesday.add(const Duration(days: 7));
    }
    setState(() {
      widget.bloc.selectedFromDay = nextTuesday;
    });
  }

  calculateAfterOneWeak() {
    DateTime currentDate = DateTime.now();

    DateTime oneWeekLater = currentDate.add(const Duration(days: 7));

    setState(() {
      widget.bloc.selectedFromDay = oneWeekLater;
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
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          shrinkWrap: true,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: customDate == "Today"
                            ? Colors.blue
                            : Colors.blue[50],
                        elevation: 0),
                    onPressed: () {
                      setState(() {
                        customDate = "Today";
                        widget.bloc.selectedFromDay = DateTime.now();
                      });
                    },
                    child: Text(
                      'Today',
                      style: semiBoldTextStyle(
                          color: customDate == "Today"
                              ? Colors.white
                              : Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: customDate == "Next Monday"
                            ? Colors.blue
                            : Colors.blue[50],
                        elevation: 0),
                    onPressed: () {
                      calculateNextMonday();
                      setState(() {
                        customDate = "Next Monday";
                      });
                    },
                    child: Text(
                      'Next Monday',
                      style: semiBoldTextStyle(
                          color: customDate == "Next Monday"
                              ? Colors.white
                              : Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: customDate == "Next Tuesday"
                            ? Colors.blue
                            : Colors.blue[50],
                        elevation: 0),
                    onPressed: () {
                      calculateNextTuesday();
                      setState(() {
                        customDate = "Next Tuesday";
                      });
                    },
                    child: Text(
                      'Next Tuesday',
                      style: semiBoldTextStyle(
                          color: customDate == "Next Tuesday"
                              ? Colors.white
                              : Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: customDate == "After 1 week"
                            ? Colors.blue
                            : Colors.blue[50],
                        elevation: 0),
                    onPressed: () {
                      calculateAfterOneWeak();
                      setState(() {
                        customDate = "After 1 week";
                      });
                    },
                    child: Text(
                      'After 1 week',
                      style: semiBoldTextStyle(
                          color: customDate == "After 1 week"
                              ? Colors.white
                              : Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
            TableCalendar(
              firstDay: DateTime(2000),
              lastDay: DateTime(2101),
              focusedDay: widget.bloc.focusedFromDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(widget.bloc.selectedFromDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (selectedDay.day == DateTime.now().day) {
                  customDate = "Today";
                } else if (dateFormatter(selectedDay
                        .toLocal()
                        .toString()
                        .split(' ')[0]
                        .toString()) ==
                    dateFormatter(checkNextMonday()
                        .toLocal()
                        .toString()
                        .split(' ')[0]
                        .toString())) {
                  customDate = "Next Monday";
                } else if (dateFormatter(selectedDay
                        .toLocal()
                        .toString()
                        .split(' ')[0]
                        .toString()) ==
                    dateFormatter(checkNextTuesday()
                        .toLocal()
                        .toString()
                        .split(' ')[0]
                        .toString())) {
                  customDate = "Next Tuesday";
                } else if (dateFormatter(selectedDay
                        .toLocal()
                        .toString()
                        .split(' ')[0]
                        .toString()) ==
                    dateFormatter(DateTime.now()
                        .add(const Duration(days: 7))
                        .toLocal()
                        .toString()
                        .split(' ')[0]
                        .toString())) {
                  customDate = "After 1 Week";
                } else {
                  customDate = "";
                }

                setState(() {
                  widget.bloc.selectedFromDay = selectedDay;
                  widget.bloc.focusedFromDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                widget.bloc.focusedFromDay = focusedDay;
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
                      widget.bloc.selectedFromDay == null
                          ? dateFormatter(widget.bloc.focusedFromDay
                              .toLocal()
                              .toString()
                              .split(' ')[0]
                              .toString())
                          : dateFormatter(
                              '${widget.bloc.selectedFromDay?.toLocal()}'
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
