import 'package:flutter/material.dart';

import '../app_scaffold.dart';
import './meditate.dart';

class MeditatePage extends StatefulWidget {
  @override
  _MeditatePageState createState() => _MeditatePageState();
}

class _MeditatePageState extends State<MeditatePage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffoldComponent(
      body: ListView(
        children: [
          Meditate(),
        ]
      )
    );
  }
}
