// this is the page about the creation of this app

import 'myapp.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('About'),
        ),
        body: const Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                  'This app was created by students at the USFQ for the Advanced Apps Programming course.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ))),
          Padding(
              padding: EdgeInsets.all(10),
              child: Text('Santellan, Atik x Tapia, Guillermo x Vivanco, Mateo',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ))),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.copyright, size: 15),
            Text(' All Rights Reserved. 2024.',
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
