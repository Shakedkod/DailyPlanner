import 'package:flutter/material.dart';

class DateServices 
{
    static DateTime mostRecentSunday(DateTime date) =>
        DateTime(date.year, date.month, date.day - date.weekday % 7);
    
    static DateTime mostRecentMonday(DateTime date) =>
        DateTime(date.year, date.month, date.day - (date.weekday - 1));

    /// The [weekday] may be 0 for Sunday, 1 for Monday, etc. up to 7 for Sunday.
    static DateTime mostRecentWeekday(DateTime date, int weekday) =>
        DateTime(date.year, date.month, date.day - (date.weekday - weekday) % 7);

    static String formatToDMY(DateTime date) =>
        "${date.day}/${date.month}/${date.year}";
    
    static Duration calculateDuration(TimeOfDay start, TimeOfDay end) =>
        Duration(hours: end.hour - start.hour, minutes: end.minute - start.minute);

    //A [compareTo] function returns:
    //a negative value if this DateTime [isBefore] [other].
    //0 if this DateTime [isAtSameMomentAs] [other], and
    //a positive value otherwise (when this DateTime [isAfter] [other]).
    static int compareTo(TimeOfDay a, TimeOfDay b) =>
        a.hour.compareTo(b.hour) == 0 ? a.minute.compareTo(b.minute) : a.hour.compareTo(b.hour);

    static int numOfWeeksInMonth(int month) =>
        DateTime(DateTime.now().year, month + 1, 0).day ~/ 7;
    
    static bool isSameDay(DateTime date1, DateTime date2) =>
        date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}