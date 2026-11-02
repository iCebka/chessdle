// this is the page to sign up to the platform

import 'package:flutter/material.dart';
import 'main.dart' show RestClient;
import 'myapp.dart';
import 'loginpage.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
        ),
        body: RegistrationForm(),
      ),
      theme: MyTheme.getTheme(),
    );
  }
}

// the body class of the registration form
class RegistrationForm extends StatelessWidget {
  RegistrationForm({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      const Icon(
        Icons.person_add_rounded,
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
          style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: AutofillHints.addressCityAndState),
          controller: usernameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Create Username',
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: AutofillHints.addressCityAndState),
          controller: passwordController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Set Password',
          ),
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const LoginPage()));
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 103, 39, 212),
            ),
          ),
          onPressed: () {
            String username = usernameController.text;
            String password = passwordController.text;

            Future<bool?> success = handleRegistration(username, password);

            success.then((value) {
              if (value == true) {
                RestClient.handleSignup(username, password);
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('Registration Successful'),
                          content:
                              const Text('You have successfully registered.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const LoginPage()));
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ));
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('Error in Registration'),
                          content: const Text(
                              'There has been an error in the registration process. Please try again.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ));
              }
            });
          },
          child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
        ),
      ])
    ]));
  }

  Future<bool?> handleRegistration(String username, String password) async {
    return await RestClient.checkSignup(username, password);
  }
}
