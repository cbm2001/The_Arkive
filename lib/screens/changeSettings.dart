import 'package:flutter/material.dart';
import 'package:first_app/navscreens/profile_screen.dart';

import '../reusable_widgets/reusable_widgets.dart';

class changeSettings extends StatefulWidget {
  final String settingType;
  const changeSettings({Key key, @required this.settingType}) : super(key: key);

  @override
  State<changeSettings> createState() => _changeSettingsState();
}

class _changeSettingsState extends State<changeSettings> {

  final TextEditingController _fieldController = TextEditingController();

  get settingType => changeSettings(settingType: settingType).settingType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
            width: 350,
            child: reusableTextField("Enter new $settingType", Icons.description,
                false, _fieldController),
            //maxLines: 8,
          ),
        ],
      ),
    );
  }
}
