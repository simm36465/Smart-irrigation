import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/*
historizes : https://api.tomorrow.io/v4/weather/history/recent?location=rabat&apikey=6MKGH2kDZsc9zDL2u7ntHB4RxNHGYMpv
api 1 : https://api.tomorrow.io/v4/weather/realtime?location=rabat&apikey=6MKGH2kDZsc9zDL2u7ntHB4RxNHGYMpv
api 2 : https://api.openweathermap.org/data/2.5/weather?q=rabat&units=metric&appid=eb42fa15c69d167b5c2aec75e7d45b12
*/

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weatherData;

  @override
  void initState() {
    super.initState();
    weatherData = fetchWeatherData();
  }

  Future<Map<String, dynamic>> fetchWeatherData() async {
    final response = await http.get(Uri.parse(
        'https://api.tomorrow.io/v4/weather/realtime?location=rabat&&units=metric&apikey=6MKGH2kDZsc9zDL2u7ntHB4RxNHGYMpv'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  /*Future<void> readJson(int weatherCode) async {
    final String response = await rootBundle.loadString('assets/json/weathercode.json');
    final dynamic jsonData = json.decode(response);

    return jsonData[weatherCode];
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView (
        child: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: weatherData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final weather = snapshot.data!;
              final weatherCode =  weather['data']['values']['weatherCode'];
              final temperature = weather['data']['values']['temperature'];
              final temperatureappart = weather['data']['values']['temperatureApparent'];
              final pressure = weather['data']['values']['pressureSurfaceLevel'];
              final humidity = weather['data']['values']['humidity'];
              final windSpeed = weather['data']['values']['windSpeed'];
              final windGust = weather['data']['values']['windGust'];
              final windDegree = weather['data']['values']['windDirection'];
              final dewPoint = weather['data']['values']['dewPoint'];
              final rainIntensity = weather['data']['values']['rainIntensity'];
              late String humdescription;
              if (humidity < 30) {
                humdescription = 'Dry air';
              } else if (humidity < 60) {
                humdescription = 'Comfortable air';
              } else {
                humdescription = 'Muggy air';
              }
              return Column(
                children: [
                  const Padding(padding:  EdgeInsets.all(16.0),
                  child: Text("Les Condition Actuelle",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
                  ) ,
                  Card(
                      elevation: 4.0,
                      child:Padding(
                          padding: const EdgeInsets.all(16.0),
                          child : ListTile(
                          title: const Text("Température",style: TextStyle(fontSize: 20,),),
                          subtitle: Text('Température apparente $temperatureappart°C', style: const TextStyle(fontSize: 12),),
                          leading: Image.asset(
                                'assets/images/external-temperature-nature-wanicon-flat-wanicon.png',
                                height: 200
                              ),
                          trailing: Text('$temperature°C',style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),),),),
                  Card(
                    elevation: 4.0,
                    child:Padding(
                      padding: const EdgeInsets.all(16.0),
                      child : ListTile(
                        title: const Text("Intensité de la pluie",style: TextStyle(fontSize: 20,)),

                        leading: Image.asset(
                            'assets/images/rain--v1.png',
                            height: 200
                        ),
                      trailing: Text('$rainIntensity mm/h',style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),),),),
                  Card(
                    elevation: 4.0,
                    child:Padding(
                      padding: const EdgeInsets.all(16.0),
                      child : ListTile(
                        title: const Text("Pression",style: TextStyle(fontSize: 20)),
                        leading: Image.asset(
                            'assets/images/pressure.png',
                            height: 200
                        ),
                        trailing: Text('$pressure hPa',style: const TextStyle(fontSize: 25,  fontWeight: FontWeight.bold)),
                      ),),),
                  Card(
                    elevation: 4.0,
                    child:Padding(
                      padding: const EdgeInsets.all(16.0),
                      child : ListTile(
                        title: const Text("Humidité",style: TextStyle(fontSize: 20)),
                        subtitle: Text('$humdescription'),
                        leading: Image.asset(
                            'assets/images/external-humidity-weather-kmg-design-flat-kmg-design.png',
                            height: 200
                        ),
                      trailing: Text('$humidity %',style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),),),),
                  Card(
                    elevation: 4.0,
                    child:Padding(
                      padding: const EdgeInsets.all(16.0),
                      child : ListTile(
                        title: const Text("Point de rosée",style: TextStyle(fontSize: 20,)),
                        leading: Image.asset(
                            'assets/images/dew-point.png',
                            height: 200
                        ),
                        trailing: Text('$dewPoint °C',style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),),),),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                    child : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                         ListTile(
                          leading: Image.asset(
                              'assets/images/wind.png',
                              height: 200
                          ),
                          title: Text('Vent',style: TextStyle(fontSize: 20,)),
                             trailing: Text('$windSpeed mph',style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[

                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(child: Icon(Icons.south_east)),
                                  TextSpan(text: '$windDegree°'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 30),
                            Text.rich(
                              TextSpan(
                                children: [

                                  WidgetSpan(child: Icon(Icons.wind_power)),
                                  TextSpan(text: '$windGust mph'),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                  ),

                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
        )
      ),
    );
  }
}
