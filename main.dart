import 'package:flutter/material.dart';
import 'package:untitled5/setting.dart';
import 'screen2.dart';
import 'screen1.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) {
          return MaterialApp(
            title: 'ArNa App',
            theme: notifier.themeMode == ThemeMode.dark
                ? ThemeData.dark()
                : ThemeData.light(),
            home: Scaffold(
              appBar: AppBar(
                title: Text('ArNa App'),
              ),
              body: const MyStatefulWidget(),
            ),
          );
        },
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: RichText(
              text: const TextSpan(children: [
                TextSpan(
                  text: 'TO',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                TextSpan(
                  text: 'DO',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                TextSpan(
                  text: 'LIST',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ]),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Log in',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              //forgot password screen
            },
            child: const Text('Forgot Password'),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              child: const Text('Login'),
              onPressed: () {
                print(nameController.text);
                print(passwordController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MenuApp();
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: (nameController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty)
                    ? Colors.green
                    : Colors.grey,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              const Text('Does not have account?'),
              TextButton(
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  //signup screen
                },
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
      ),
    );
  }
}
