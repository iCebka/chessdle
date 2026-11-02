// this is the main page of each of the board game's information

import 'package:flutter/material.dart';
import 'myapp.dart';
import 'main.dart' show RestClient;
import '../board/board_stuff/game_board.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OpeningPage extends StatelessWidget {
  const OpeningPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: const Color.fromARGB(255, 103, 39, 212),
          centerTitle: true,
        ),
        body: GameInfo(title: title));
  }
}

class GameInfo extends StatefulWidget {
  const GameInfo({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<StatefulWidget> createState() => _GameInfoState();
}

Future<List<String>> _lookFor(String logo) async{
    var url = Uri.parse('http://localhost:8080/variantes?log=$logo');
    var response = await http.get(url);
    List<String>vars = [];
    if (response.statusCode == 200){
      var bodyUtf8 = utf8.decode(response.bodyBytes);
      //print(logo);
      if (bodyUtf8 != ""){
        List<dynamic> variantes = jsonDecode(bodyUtf8);
        for (var variante in variantes){
          //print('${variante['name']} - ${variante['log']}');
          vars.add ( ('${variante['eco']} - ${variante['name']} / ${variante['log']}'));
        }
      }
      return vars;
    }
    else{
      throw Exception("No se pudo conectar a la API");
    }
  }

class _GameInfoState extends State<GameInfo> {
  late Future<String> overview;
  late Future<String> fullTitle;
  late Future<String> moves;
  late Future<Map<String, String>> variations;
  late Future<String> author;

  late Future<bool> isFav;
  late bool toggleButton;

  String logi = "";
  late Future<dynamic> variants;

  @override
  void initState() {
    super.initState();
    overview = RestClient.getOverview(widget.title);
    fullTitle = RestClient.getTitle(widget.title);
    moves = RestClient.getMoves(widget.title);
    variations = RestClient.getVariations(widget.title);
    author = RestClient.getAuthor(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    isFav = RestClient.checkFav(widget.title);
    return SingleChildScrollView(
      controller: ScrollController(),
      child: Column(
        children: <Widget>[
          Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 4)),
                    child: FutureBuilder<String>(
                        future: moves,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SizedBox(
                                height: 340,
                                width: 270,
                                child: GameBoard(movesList: snapshot.data!));
                          } else if (snapshot.hasError) {
                            return const Text('Error loading image');
                          }
                          //print(snapshot.data);
                          return const CircularProgressIndicator();
                        }),
                  ))),
          FutureBuilder<String>(
              future: fullTitle,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(snapshot.data!,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      MyApp.getUsername() == 'username'
                          ? Container()
                          : IconButton(
                              icon: FutureBuilder<bool>(
                                  future: isFav,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      toggleButton = snapshot.data!;
                                      return toggleButton
                                          ? const Icon(Icons.favorite)
                                          : const Icon(Icons.favorite_border);
                                    } else if (snapshot.hasError) {
                                      return Container();
                                    }
                                    return const CircularProgressIndicator();
                                  }),
                              onPressed: () => {
                                setState(() {
                                  toggleButton = !toggleButton;
                                  if (toggleButton) {
                                    RestClient.addToFav(widget.title);
                                  } else {
                                    RestClient.removeFav(widget.title);
                                  }
                                }),
                                // add to favorites
                              },
                            ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error loading title');
                }
                return const CircularProgressIndicator();
              }),
          const Text("Overview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: const Divider(
                color: Color.fromARGB(255, 103, 39, 212),
                thickness: 2,
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
              child: FutureBuilder<String>(
                future: overview,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                            fontFamily: AutofillHints.addressCityAndState,
                            fontSize: 20,
                            fontWeight: FontWeight.normal));
                  } else if (snapshot.hasError) {
                    return const Text('Error loading overview');
                  }
                  return const CircularProgressIndicator();
                },
              )),
          FutureBuilder(
              future: author,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text("Author: ${snapshot.data!}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold, fontFamily: AutofillHints.addressCityAndState));
                } else if (snapshot.hasError) {
                  return const Text('Error loading author');
                }
                return const CircularProgressIndicator();
              }),
          Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: const Divider(
                color: Color.fromARGB(255, 103, 39, 212),
                thickness: 2,
              )),
          FutureBuilder(
              future: variations,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String,String> variant = snapshot.data as Map<String,String>;
                  String firstValue = variant.keys.first;
                  String? firstElement = variant[firstValue];
                  print("$firstValue y $firstElement");
                  return Column(
                    children: [
                      const Text("Variations",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: const Divider(
                            color: Color.fromARGB(255, 103, 39, 212),
                            thickness: 2,
                          )),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
                          child: Column(
                            children: snapshot.data!.entries.map((move) {
                              return Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 8.0),
                                    child: Image.asset("assets/images/blueboard.png",
                                    width: 75.0,
                                    height: 75.0),
                                  ),
                                Expanded(
                                  child: Text(move.value,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal)),
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_forward),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(//Ventana de previsualización de apertura
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [Align(
                                                      alignment: Alignment.topRight,
                                                      child: IconButton(
                                                        icon: Icon(Icons.close),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ),
                                                Text(firstElement!),
                                                SizedBox(height: 8.0),
                                                //Image.asset('assets/images/blueboard.png'),
                                                SizedBox(
                                                  height: 340,
                                                  width: 270,
                                                  child: GameBoard(movesList: firstValue)),
                                                //Text(variants[index]['log']),
                                                SizedBox(height: 8.0),
                                                Text(firstValue),
                                              ],
                                            ),
                                            
                                          );
                                        },
                                      );
                                  },
                                ),
                                
                              ]);
                            }).toList(),
                          )),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error loading variations');
                }
                return const CircularProgressIndicator();
              })
        ],
      ),
    );
  }
}
