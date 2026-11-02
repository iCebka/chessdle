// the page to manage the settings of the app

import 'package:flutter/material.dart';
import 'myapp.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SETTINGS'),
        ),
        body: const Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                  'This app is so cool! Why would you need to change anything?',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ))),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Go on and play with your friends! (if you have any)',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                )),
          ]),
        ])),
        drawer: const NavigationSideBar(),
      ),
      theme: MyTheme.getTheme(),
    );
  }
}