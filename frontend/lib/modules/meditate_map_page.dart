import 'package:flutter/material.dart';

import '../app_scaffold.dart';
import './meditate_map.dart';

class MeditateMapPage extends StatefulWidget {
  @override
  _MeditateMapPageState createState() => _MeditateMapPageState();
}

class _MeditateMapPageState extends State<MeditateMapPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffoldComponent(
      body: ListView(
        children: [
          MeditateMap(mapHeight: 300),
        ]
      )
    );
  }
}
