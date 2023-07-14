import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'main.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    ));

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Timer(Duration(seconds: 10), () {
        Navigator.of(context).pop();
      });
      return AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          )
        ],
      );
    },
  );
}

class _LoginScreenState extends State<LoginScreen> {

  final auth = FirebaseAuth.instance;
  late String email;
  late String pass;

  @override
  void initState() {
    super.initState();
    checkCurrentUser();
  }

  void checkCurrentUser() async {
    var user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: Container(
                          margin: const EdgeInsets.only(top: 360),
                          child: const Center(
                            heightFactor: 1.0,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              const BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey[200]!))),
                              child: TextField(
                                onChanged: (value) => {email = value},
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email or Phone number",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                obscureText: true,
                                onChanged: (value) => {pass = value},
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF53BE53), // Green
                              Color(0xFF00EF00), // Dark green
                            ],
                          ),
                        ),
                        child: SizedBox(
                          width: 400,
                        child : ElevatedButton(
                          onPressed:  () async {
                            try {
                              var user = await auth.signInWithEmailAndPassword(
                                  email: email, password: pass);
                              if (user != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage()),
                                );
                              }
                            } catch (e) {
                              _showErrorDialog(context, e.toString());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            elevation: 0,
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        )),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      const Image(
                        image: AssetImage('assets/images/7.jpg'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
