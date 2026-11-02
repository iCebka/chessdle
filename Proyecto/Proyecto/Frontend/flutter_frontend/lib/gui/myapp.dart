import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart' show RestClient;
import 'myhomepage.dart';
import 'explorepage.dart';
import 'settingspage.dart';
import 'loggeduserpage.dart';
import 'aboutpage.dart';
import 'loginpage.dart';
import 'discoverpage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static String username = 'username';

  static String getUsername() {
    return username;
  }

  static void setUsername(String name) {
    username = name;
  }

  // function to load the current logged user's name
  static Future<String?> loadUsername() async {
    return await RestClient.getLoggedUser();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //load the current logged user in the server
    loadUsername().then((value) => setUsername(value!));

    return MaterialApp(
      title: 'ChessDle Experience',
      theme: MyTheme.getTheme(),
      home: const MyHomePage(),
    );
  }
}

//default theme data of the app to be used everywhere in the app
class MyTheme {
  const MyTheme();

  static getTheme() => ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 103, 39, 212)),
        useMaterial3: true,
        fontFamily: GoogleFonts.silkscreen().fontFamily,
        primarySwatch: Colors.deepPurple,
      );
}

// navigation side bar class
class NavigationSideBar extends StatelessWidget {
  const NavigationSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        Expanded(
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 116, 0, 248),
            ),
            child: Text('Chess\n  + \nWordle',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    shadows: [Shadow(color: Colors.white, blurRadius: 17)])),
          ),
          ListTile(
            title: const Text('START'),
            leading: const Icon(Icons.home),
            iconColor: const Color.fromARGB(255, 255, 111, 0),
            onTap: () {
              // close the drawer on tappings
              Navigator.pop(context);
              // Update the state of the app
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const MyHomePage(),
              ));
            },
          ),
          ListTile(
            title: const Text('EXPLORE'),
            leading: const Icon(Icons.near_me),
            iconColor: const Color.fromARGB(255, 255, 111, 0),
            onTap: () {
              // close the drawer on tapping
              Navigator.pop(context);
              // Update the state of the app
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const ExplorePage(),
              ));
            },
          ),
          ListTile(
            title: const Text('DISCOVERIES'),
            leading: const Icon(Icons.bookmarks),
            iconColor: const Color.fromARGB(255, 255, 111, 0),
            onTap: () {
              // close the drawer on tapping
              Navigator.pop(context);
              // Update the state of the app
              if (MyApp.username == "username") {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const DiscoverPage(),
                ));
              }
            },
          ),
          ListTile(
            title: const Text('ABOUT'),
            leading: const Icon(Icons.outlet_rounded),
            iconColor: const Color.fromARGB(255, 255, 111, 0),
            onTap: () {
              // close the drawer on tapping
              Navigator.pop(context);
              // Update the state of the app
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const AboutPage(),
              ));
            },
          ),
          MyApp.getUsername() == 'username'
              ? Container()
              : Center(
                  child: ListTile(
                  title: const Text('Log out'),
                  leading: const Icon(Icons.logout),
                  iconColor: Colors.red,
                  onTap: () {
                    // close the drawer on tapping
                    Navigator.pop(context);
                    // Update the state of the app
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
                    RestClient.logout();
                    MyApp.setUsername('username'); // resets the default username
                  },
                ))
        ])),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.settings),
              iconSize: 50,
              onPressed: () {
                // close the drawer on tapping
                Navigator.pop(context);
                // Update the state of the app
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ));
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_circle),
              iconSize: 50,
              onPressed: () {
                // close the drawer on tapping
                Navigator.pop(context);
                // Update the state of the app
                if (MyApp.username == "username") {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ));
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => LoggedUserPage(name: MyApp.username),
                  ));
                }
              },
            )
          ],
        ),
      ],
    ));
  }
}
