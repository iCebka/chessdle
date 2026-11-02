// the page for the user's discovered openings

import 'package:flutter/material.dart';
import 'myapp.dart';
import 'openingcard.dart';
import 'main.dart' show RestClient;

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Discovered'),
          ),
          drawer: const NavigationSideBar(),
          body: const DiscoverList()),
      theme: MyTheme.getTheme(),
    );
  }
}

class DiscoverList extends StatefulWidget {
  const DiscoverList({super.key});

  @override
  State<StatefulWidget> createState() => _DiscoverListState();
}

class _DiscoverListState extends State<DiscoverList> {
  late Future<List<String>> ops;

  @override
  void initState() {
    super.initState();
    ops = RestClient.getDiscovered();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: FutureBuilder<List<String>>(
              future: ops,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    runSpacing: 2,
                    spacing: 2,
                    children: snapshot.data!.map((name) {
                      return OpeningCard(name: name);
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error loading games');
                }
                return const CircularProgressIndicator();
              }))
    ]);
  }
}
