// the logged in user's page
import 'package:flutter/material.dart';
import 'myapp.dart';
import 'main.dart' show RestClient;
import 'openingcard.dart';

class LoggedUserPage extends StatefulWidget {
  const LoggedUserPage({super.key, required this.name});

  final String name;

  @override
  State<StatefulWidget> createState() => _LoggedUserPageState();
}

class _LoggedUserPageState extends State<LoggedUserPage> {
  late Future<List<String>> saved;
  late Future<String> biography;
  late String bio;

  final updateBiographyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    biography = RestClient.getBio(widget.name).then((value) => value);
  }

  @override
  Widget build(BuildContext context) {
    saved = RestClient.getFavs(widget.name);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white10,
          title: const Text("YOUR USER PROFILE", textAlign: TextAlign.center),
        ),
        body: Column(children: [
          const Center(child: Icon(Icons.account_circle, size: 100)),
          Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Text("Welcome, ${widget.name}",
                    style: const TextStyle(fontSize: 20)),
              ])),
          Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: const Divider(
                color: Color.fromARGB(255, 103, 39, 212),
                thickness: 2,
              )),
          InkWell(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: FutureBuilder<String>(
                  future: biography,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      bio = snapshot.data!;
                      return Text(bio,
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
            onTap: () => {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text('Edit Your Biography'),
                        actions: <Widget>[
                          TextField(
                            style: const TextStyle(fontSize: 20, fontFamily: AutofillHints.addressCityAndState),
                            controller: updateBiographyController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter your new biography'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                biography = RestClient.setBio(
                                    updateBiographyController.text);
                              });
                            },
                            child: const Text('ACCEPT'),
                          ),
                        ],
                      ))
            },
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: const Divider(
                color: Color.fromARGB(255, 103, 39, 212),
                thickness: 2,
              )),
          const Text("Favourite Openings",
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
