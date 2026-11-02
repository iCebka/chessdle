import 'package:flutter/material.dart';
import 'package:flutter_frontend/gui/main.dart';
import 'myapp.dart';
import '../wordle/wordlescreen.dart';
import 'main.dart' show RestClient;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  final String title = 'Chess + Wordle';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final Future<String> word;

  @override
  void initState() {
    super.initState();
    // RestClient.startGame();
    // word = RestClient.getCurrentWord();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
          ),
          drawer: const NavigationSideBar(),
          body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Welcome to the Chessle Experience!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ))),
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                    'Just tap below to start the game or on the three bars on the left to navigate!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    )),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                onPressed: () {
                  RestClient.startGame();

                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => FutureBuilder(
                          future: RestClient.getCurrentWord(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return WordleScreen(word: snapshot.data!);
                            } else if (snapshot.hasError) {
                              return const Text('Error loading word');
                            }
                            return const CircularProgressIndicator();
                          })));
                },
                child: const Text('Start Playing',
                    style: TextStyle(color: Colors.black)),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 60, 15, 0),
                child: Text(
                    'Remember to sign in to save your discoveries!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    )),
              ),
            ]),
          )),
      theme: MyTheme.getTheme(),
    );
  } // This trailing comma makes auto-formatting nicer for build methods.
}
