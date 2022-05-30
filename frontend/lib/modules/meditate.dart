import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../app_scaffold.dart';
import '../../common/localstorage_service.dart';
import '../../common/form_input/input_fields.dart';
import '../../common/socket_service.dart';
import '../../common/datetime_service.dart';

class Meditate extends StatefulWidget {
  @override
  _MeditateState createState() => _MeditateState();
}

class _MeditateState extends State<Meditate> {
  InputFields _inputFields = InputFields();
  LocalstorageService _localstorageService = LocalstorageService();
  SocketService _socketService = SocketService();
  DatetimeService _datetimeService = DatetimeService();

  List<String> _routeIds = [];

  var formVals = {
    'timeMinutes': 60,
  };
  Timer? _timer = null;
  int _secondsRemaining = 60 * 60;
  int _elapsedSeconds = 0;
  String _timeState = "stopped"; // "stopped" or "running"
  bool _inited = false;
  String _localstorageKey = 'meditateTimeMinutes';

  double? _latitude = 0;
  double? _longitude = 0;
  //LocationData? _locationData;
  String _startSessionKey = '';

  @override
  void initState() {
    getLocation();
    _startSessionKey = _datetimeService.stringFormat(DateTime.now());
    print ('_startSessionKey ${_startSessionKey} ${_latitude} ${_longitude}');

    _routeIds.add(_socketService.onRoute('saveUserMeditation', callback: (String resString) {
      var res = json.decode(resString);
      var data = res['data'];
      print ('data ${data}');
    }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_inited) {
      var timeMinutesString = _localstorageService.getItem(_localstorageKey);
      if (timeMinutesString != null) {
        int timeMinutes = int.parse(timeMinutesString);
        formVals['timeMinutes'] = timeMinutes;
        _secondsRemaining = timeMinutes * 60;
      }
      _inited = true;
    }

    //String buttonText = _timeState == "running" ? "Pause" : "Start";
    String meditateIconPath = _timeState == "running" ? "assets/images/timer_active.png" : "assets/images/timer_inactive.png";
    String elapsedMinutesString = _datetimeService.twoDigits((_elapsedSeconds / 60).floor());
    String elapsedSecondsString = _datetimeService.twoDigits(_elapsedSeconds % 60);
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 300,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text('Welcome'),
            //SizedBox(height: 10),
            IconButton(
              icon: Image.asset(meditateIconPath, width: 300, height: 300),
              iconSize: 300,
              onPressed: () {
                toggleTimerState();
              }
            ),
            //ElevatedButton(
            //  onPressed: () {
            //    toggleTimerState();
            //  },
            //  child: Text(buttonText),
            //),
            SizedBox(height: 10),
            _inputFields.inputNumber(context, formVals, 'timeMinutes', label: 'Minutes', debounceChange: 1000, onChange: (double? val) {
              stopTimer();
              _secondsRemaining = (val! * 60).floor();
              _elapsedSeconds = 0;
              _localstorageService.setItem(_localstorageKey, val.toString());
            }),
            SizedBox(height: 10),
            Text('${elapsedMinutesString}:${elapsedSecondsString}'),
          ]
        )
      )
    );
  }

  @override
  void dispose() {
    clearTimer();
    _socketService.offRouteIds(_routeIds);
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_secondsRemaining == 0) {
          if (_timer != null) {
            stopTimer();
          }
        } else {
          if (_timeState == "running") {
            setState(() {
              _secondsRemaining--;
              _elapsedSeconds++;
            });
          }
        }
      },
    );
  }

  void clearTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  void stopTimer() {
    _timeState = "stopped";
    clearTimer();
    setState(() {
      _timeState = _timeState;
    });
  }

  void toggleTimerState() {
    if (_timeState == "running") {
      stopTimer();
    } else {
      _timeState = "running";
      setState(() {
        _timeState = _timeState;
      });
      startTimer();
    }
  }

  void getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData locationData = await location.getLocation();
    _latitude = locationData.latitude;
    _longitude = locationData.longitude;
    print ('locationData ${locationData}');
  }
}
