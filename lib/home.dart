import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'Screens/capteurs.dart';
import 'Screens/historyScreen.dart';
import 'Screens/reservoirScreen.dart';
import 'Screens/vanes.dart';
import 'Screens/weather.dart';
import 'login.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const WeatherScreen(),
    VanesScreen(),
    HistoricScreen(),
    capteurScreen(),
    ReservoirScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    void _logout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage()),
      );
    }
    if (user != null) {
      // User is signed in. Navigate to the home screen.
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title:  Text("Smart Irrigation"),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              tooltip: 'Se déconnecter',
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.topSlide,
                  title: 'Confirmer la déconnexion',
                  desc: 'Êtes-vous certain de vouloir vous déconnecter?',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {
                    _logout();
                  },
                ).show();
              },
            ),
          ],
        ),
        body: Center(
          child: _screens[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.green, // Set the color of the selected item
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.cloud,
              ),
              label: 'météo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.water_drop),
              label: 'pompes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'historique',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.electrical_services),
              label: 'capteurs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.straighten_outlined),
              label: 'réservoir',
            ),
          ],
        ),
      );
    } else {
      // No user is signed in. Navigate to the login screen.
      return LoginScreen();
    }

  }
}

