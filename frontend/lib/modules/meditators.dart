import 'package:flutter/material.dart';

import '../app_scaffold.dart';

class Meditators extends StatefulWidget {
  @override
  _MeditatorsState createState() => _MeditatorsState();
}

class _MeditatorsState extends State<Meditators> {

  List<String> _meditators = [
    'Susan',
    'Beks',
    'Prem',
    'Niraj',
    'Grant',
    'Jason',
    'Monnet',
    'Ogi',
    'Nestor',
    'Ashton',
    'Sarah A.',
    'Zia',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sadhaks Meditating: ${_meditators.length}'),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              ..._meditators.map((meditator) => _buildMeditator(context, meditator) ).toList(),
            ]
          ),
        ]
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildMeditator(context, user) {
    return Container(
      width: 150,
      child: Text(user),
    );
  }
}
