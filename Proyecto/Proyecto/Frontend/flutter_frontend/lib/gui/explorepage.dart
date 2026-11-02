// page to explore all the board games in the repository

import 'package:flutter/material.dart';
import 'myapp.dart';
import 'openingcard.dart';
import 'main.dart' show RestClient;

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Explore'),
          ),
          drawer: const NavigationSideBar(),
          body: const ExploreList()),
      theme: MyTheme.getTheme(),
    );
  }
}

class ExploreList extends StatefulWidget {
  const ExploreList({super.key});

  @override
  State<StatefulWidget> createState() => _ExploreListState();
}

class _ExploreListState extends State<ExploreList> {
  late Future<List<String>> ops;

  @override
  void initState() {
    super.initState();
    ops = RestClient.getOpenings();
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
