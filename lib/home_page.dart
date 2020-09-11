import 'package:flutter/material.dart';

import 'my_app_bar.dart';

class DartTutorialHomePage extends StatefulWidget {
  DartTutorialHomePage();
  @override
  _DartTutorialHomePageState createState() => _DartTutorialHomePageState();
}

class _DartTutorialHomePageState extends State<DartTutorialHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Center(
        child: Text('Change theme Color'),
      ),
    );
  }
}
