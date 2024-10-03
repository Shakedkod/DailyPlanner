import 'package:daily_planner/services/dateServices.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class CustomDatePickerTimeline extends StatefulWidget 
{
    final DateTime selectedDate;
    final Function(DateTime) onDateSelected;

    const CustomDatePickerTimeline({
        super.key,
        required this.selectedDate,
        required this.onDateSelected,
    });

    @override
    _CustomDatePickerTimelineState createState() => _CustomDatePickerTimelineState();
}

class _CustomDatePickerTimelineState extends State<CustomDatePickerTimeline> {
    DateTime _selectedDate = DateTime.now();

    @override
    void initState() 
    {
        super.initState();
        _selectedDate = widget.selectedDate;
    }

    @override
    Widget build(BuildContext context)
    {
        return DatePicker(
            DateServices.mostRecentSunday(DateTime.now()),
            locale: "he_IL", // Set Hebrew locale
            initialSelectedDate: widget.selectedDate,
            selectedTextColor: Colors.black,
            daysCount: DateTime.now().weekday > 4 ? 14 : 7,
            dayTextStyle: const TextStyle(fontSize: 12),
            dateTextStyle: const TextStyle(fontSize: 16),
            monthTextStyle: const TextStyle(fontSize: 12),
            width: MediaQuery.of(context).size.width / 7.8,
            onDateChange: (date) {
                setState(() {
                    _selectedDate = date;
                    widget.onDateSelected(date);
                });
            },
        );
    }
}