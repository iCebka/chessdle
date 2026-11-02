// the page to handle the login of the user

import 'loggeduserpage.dart';
import 'package:flutter/material.dart';

import 'myapp.dart';
import 'registrationpage.dart';
import 'main.dart' show RestClient;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: LoginBody(),
        drawer: const NavigationSideBar(),
      ),
      theme: MyTheme.getTheme(),
    );
  }
}

// class with a classic login form
class LoginBody extends StatelessWidget {
  LoginBody({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Center(
      child: Column(
        children: [
          const Icon(
            Icons.videogame_asset,
            size: 100,
            color: Color.fromARGB(255, 255, 111, 0),
          ),
          const Text('Chessle Experience',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 103, 39, 212),
              )),
           Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: AutofillHints.addressCityAndState),
              controller: usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: AutofillHints.addressCityAndState),
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 103, 39, 212),
              ),
            ),
            onPressed: () {
            
            String username = usernameController.text;
            String password = passwordController.text;

            Future<bool?> success = check(username, password);

            success.then((value) {
              if (value == true) {
                RestClient.handleLogin(username, password); // handles the login of the user to the server
                MyApp.setUsername(username); // updates the name of the current logged user within the app
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text('Welcome back, $username!'),
                          content:
                              const Text('You have successfully logged in!'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoggedUserPage(name: username)));
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ));
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('Invalid Login Credentials'),
                          content: const Text(
                              'There has been an error. Please try again.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ));
              }});
            },
            child: const Text('Sign In', style: TextStyle(color: Colors.white)),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account? ',
                      style: TextStyle(fontSize: 15)),
                  InkWell(
                    onTap: () => {
                      Navigator.of(context).pop(),
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RegistrationPage(),
                        ),
                      )
                    },
                    child: const Text(
                      'Sign up here!',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ))
        ],
      ),
    ));
  }
}

Future<bool?> check(String username, String password) async {
  return await RestClient.checkLogin(username, password);
}