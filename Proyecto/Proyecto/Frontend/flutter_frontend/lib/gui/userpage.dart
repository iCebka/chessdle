// the logged in user's page
import 'package:flutter/material.dart';
import 'myapp.dart';
import 'main.dart' show RestClient;
import 'openingcard.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.name});

  final String name;

  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<List<String>> saved;
  late Future<String> biography;

  final updateBiographyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    saved = RestClient.getFavs(widget.name);
    biography = RestClient.getBio(widget.name).then((value) => value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("USER PROFILE", textAlign: TextAlign.center),
        ),
        body: Column(children: [
          const Center(child: Icon(Icons.account_circle, size: 100)),
          Center(
              child: Text("Welcome, ${widget.name}",
                  style: const TextStyle(fontSize: 20))),
          Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: const Divider(
                color: Color.fromARGB(255, 103, 39, 212),
                thickness: 2,
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: FutureBuilder<String>(
                future: biography,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                            fontFamily: AutofillHints.addressCityAndState,
                            fontSize: 20,
                            fontWeight: FontWeight.normal));
                  } else if (snapshot.hasError) {
                    return const Text("No biography available.");
                  }
                  return const CircularProgressIndicator();
                },
              )),
          Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: const Divider(
                color: Color.fromARGB(255, 103, 39, 212),
                thickness: 2,
              )),
          const Text("Games In Collection",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          FutureBuilder<List<String>>(
              future: saved,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    runSpacing: 2,
                    spacing: 2,
                    children: snapshot.data!.map((game) {
                      return OpeningCard(name: game);
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error loading saved games');
                }
                return const CircularProgressIndicator();
              }),
        ]),
        drawer: const NavigationSideBar(),
      ),
      theme: MyTheme.getTheme(),
    );
  }
}
