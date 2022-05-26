import 'dart:math';
import 'package:flutter/material.dart';
  
class DatetimeService {
  DatetimeService._privateConstructor();
  static final DatetimeService _instance = DatetimeService._privateConstructor();
  factory DatetimeService() {
    return _instance;
  }

  String twoDigits(int val) {
  	String valString = val.toString();
  	if (valString.length == 1) {
  		valString = "0${valString}";
  	}
  	return valString;
  }

  String formatOffset(int minutes) {
  	String valString = "";
  	if (minutes < 0) {
  		valString = "-";
  	}
  	minutes = minutes.abs();
  	int hours = (minutes / 60).floor();
  	minutes = minutes % 60;
  	valString = "${valString}${twoDigits(hours)}${twoDigits(minutes)}";
  	return valString;
  }

  String stringFormat(DateTime datetime) {
	String y = datetime.year.toString();
	String m = twoDigits(datetime.month);
	String d = twoDigits(datetime.day);
	String h = twoDigits(datetime.hour);
	String min = twoDigits(datetime.minute);
	String sec = twoDigits(datetime.second);
	String offset = formatOffset(datetime.timeZoneOffset.inMinutes);
  	return '$y-$m-$d $h:$min:$sec $offset';
  }

  DateTime fromString(String datetimeString) {
  	return DateTime.parse(datetimeString);
  }
}
