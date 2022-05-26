import 'dart:async';
import 'package:flutter/material.dart';

import '../app_scaffold.dart';
import './meditate_map.dart';
import './meditate.dart';

class HomeComponent extends StatefulWidget {
  @override
  _HomeComponentState createState() => _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldComponent(
      body: ListView(
        children: [
          MeditateMap(mapHeight: 300),
          SizedBox(height: 10),
          Meditate(),
          SizedBox(height: 10),
        ]
      )
    );
  }
}
