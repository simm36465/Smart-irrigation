import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class capteurScreen extends StatefulWidget {

  const capteurScreen({super.key});

  @override
  State<capteurScreen> createState() => _capteurScreenState();
}

class _capteurScreenState extends State<capteurScreen> {
  int? _selectedSensorIndex;
  bool isLoading = true;
  String humidityValue = '';
  String  soil_moistureValue = '';
  String  temperatureValue = '';
  String  water_levelValue = '';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
    initializeNotifications();
    getHumidity();
    getsoil_moisture();
    gettemperature();
    getwater_level();

  }

  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: 'XX',
    );
  }



  void getHumidity() {
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("aquaflow/SENSORS/humidity");
    reference.onValue.listen((event) {
      setState(() {
        humidityValue = event.snapshot.value.toString();
        isLoading = false;
        // Check if humidity is low (e.g., less than 30%)
        if (humidityValue.isNotEmpty && double.parse(humidityValue) < 30) {
          showNotification('Low Humidity', 'The humidity level is low.');
        }
      });
    });
  }

  void getsoil_moisture() {
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("aquaflow/SENSORS/soil_moisture");
    reference.onValue.listen((event) {
      setState(() {
        if (soil_moistureValue.isNotEmpty && double.parse(soil_moistureValue) == 0) {
          showNotification('soil moisture', 'Your plante need water');
        }
        soil_moistureValue = event.snapshot.value.toString();
        isLoading = false;

      });
    });
  }
  void gettemperature() {
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("aquaflow/SENSORS/temperature");
    reference.onValue.listen((event) {
      setState(() {
        temperatureValue = event.snapshot.value.toString();
        isLoading = false;
        if (temperatureValue.isNotEmpty && double.parse(temperatureValue) > 20) {
          showNotification('Temperateur is very high', 'Temperateur is very high you need to irrigation');
        }
      });
    });
  }
  void getwater_level() {
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("aquaflow/SENSORS/water_level");
    reference.onValue.listen((event) {
      setState(() {
        water_levelValue = event.snapshot.value.toString();
        isLoading = false;
        if (water_levelValue.isNotEmpty && double.parse(water_levelValue) < 20) {
          showNotification('Low Water Level', 'The water level is low.');
        }
      });
    });
  }
  // Define a function to handle the card tap
  void _handleCardTap(int index, String sensorImg, String name, String Volt, String Current, String rt, String rh, String type ) {
    setState(() {
      _selectedSensorIndex = index;
    });
    // Show the sensor details modal
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sensor Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image(
                  image: AssetImage(sensorImg),
                ),
              ),
              Text(
                'Sensor $index :  $name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children:  <TextSpan>[
                    const TextSpan(
                        text: 'operating voltage : ',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, height: 2)),
                    TextSpan(text: '$Volt'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children:  <TextSpan>[
                    TextSpan(
                        text: 'sensor type : ',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, height: 2)),
                    TextSpan(text: '$type'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children:  <TextSpan>[
                    TextSpan(
                        text: 'range temperature : ',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, height: 2)),
                    TextSpan(text: '$rt'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children:  <TextSpan>[
                    TextSpan(
                        text: 'range humidity : ',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, height: 2)),
                    TextSpan(text: '$rh'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _selectedSensorIndex = null;
                });
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Les Capteurs Actuelle",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )),
              Card(
                elevation: 4.0,
                child: InkWell(
                  onTap: () =>
                      _handleCardTap(
                          0,
                          "assets/images/dht11.png",
                          "Temperature",
                          "3.5V to 5.5V",
                          "0.3mA to 60uA",
                          "0°C to 50°C",
                          "20% to 90%",
                          "Serial "),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      title: const Text(
                        "temperature",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        'temperature-sensor',
                        style: const TextStyle(fontSize: 12),
                      ),
                      leading: Image.asset(
                          'assets/images/temperature-sensor.png',
                          height: 200),
                      trailing: isLoading
                        ? const CircularProgressIndicator()
                          : humidityValue == null
                  ? const Text('not available')
                        : Text(temperatureValue + "°C",
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                child: InkWell(
                  onTap: () =>
                      _handleCardTap(
                          1,
                          "assets/images/dht11.png",
                          "Humidity",
                          "3.3V to 5V",
                          "35mA",
                          " -40℃~ +60℃",
                          "0% to 950%",
                          "analog"),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      title: const Text("Humidity",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      subtitle: Text(
                        'Humidity Sensor',
                        style: const TextStyle(fontSize: 12),
                      ),
                      leading: Image.asset('assets/images/humidity-sensor.png',
                          height: 200),
                      trailing:isLoading
                          ? const CircularProgressIndicator()
                          : humidityValue == null
                          ? const Text('not available')
                          : Text(humidityValue + '%',
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                child: InkWell(
                  onTap: () =>
                      _handleCardTap(
                          1,
                          "assets/images/meter.png",
                          "Soil Moisture",
                          "3.3V to 5V",
                          "35mA",
                          " -40℃~ +60℃",
                          "0% to 950%",
                          "analog"),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      title: const Text("Soil Moisture",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      subtitle: Text(
                        'Soil Moisture Sensor',
                        style: const TextStyle(fontSize: 12),
                      ),
                      leading: Image.asset('assets/images/meter.png',
                          height: 200),
                      trailing: isLoading
                          ? const CircularProgressIndicator()
                          : humidityValue == null
                          ? const Text('not available')
                          : Text(soil_moistureValue + '%',
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),

                    ),
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                child: InkWell(
                  onTap: () =>
                      _handleCardTap(
                          3,
                          "assets/images/water.png",
                          "Water-level",
                          "5V",
                          "20mA",
                          "10°C to -30°C",
                          "10% to 90%",
                          "analog"),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      title:
                      const Text("water-level", style: TextStyle(fontSize: 20)),
                      leading:
                      Image.asset('assets/images/water-level.png', height: 200),
                      subtitle: Text(
                        'Water Level Sensor',
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Text(water_levelValue + "%",

                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),

            ],
          ),
        )
    );
  }
}
