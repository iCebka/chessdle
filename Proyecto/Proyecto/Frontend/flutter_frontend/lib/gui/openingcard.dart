// this is a class that creates the presentation card for each board game

import 'openingpage.dart';
import 'package:flutter/material.dart';
//import 'main.dart' show RestClient;

class OpeningCard extends StatelessWidget {
  const OpeningCard({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OpeningPage(
                title: name,
              ),
            ),
          );
        },
        child: SizedBox(
            height: 130,
            width: 200,
            child: Card(
              elevation: 9,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const Image(
                            image: AssetImage("assets/images/blueboard.png"),
                            fit: BoxFit.cover,
                            height: 130,
                            width: 200,
                            alignment: Alignment.center)),
                    Positioned(
                        bottom: 0,
                        child: Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          color: Colors.white.withOpacity(0.6),
                          child: Text(name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(color: Colors.white, blurRadius: 20)
                                  ])),
                        ))
                  ],
                ),
              ),
            )));
  }
}
