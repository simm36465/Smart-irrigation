import 'package:flutter/material.dart';
import 'package:water_bottle/water_bottle.dart';
class ReservoirScreen extends StatefulWidget {
  const ReservoirScreen({super.key});

  @override
  State<ReservoirScreen> createState() => _ReservoirScreenState();
}

class _ReservoirScreenState extends State<ReservoirScreen> {
  bool isChecked = false; // new variable
  bool iSwitched = false;
  void _showNumberFieldModal() {
    int selectedLevel = 0;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select pump level:',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              DropdownButton<int>(
                value: selectedLevel,
                items: List.generate(
                  10,
                      (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('Level ${index + 1}'),
                  ),
                ),
                onChanged: (int? value) {
                  setState(() {
                    selectedLevel = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // start pump with selected level
                  Navigator.of(context).pop();
                },
                child: Text('Start Pump'),
              ),
            ],
          ),
        );
      },
    );
  }



  final plainBottleRef = GlobalKey<WaterBottleState>();
  var waterLevel = 0.6;
  @override
  Widget build(BuildContext context) {
    final plain = WaterBottle(
        key: plainBottleRef,
        waterColor: Colors.blue,
        bottleColor: Colors.lightBlue,
        capColor: Colors.white10);
    setState(() {
      plainBottleRef.currentState?.waterLevel = waterLevel;
    });

    final bottle = Center(
      child: SizedBox(
        width: 200,
        height: 300,
        child:plain,
      ),
    );
    final TitleDisplay = Center(
      child : Container(
        margin: EdgeInsets.only(top: 30.0, bottom: 70.0),
        child: Text("niveau d'eau", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)
    ));
    List<Map<String, dynamic>> items = [
    {'imageUrl': 'assets/images/pump.png',
    'title': 'Pompe 1',
    'subtitle': 'Pomp pour rempli le reservoir',
    'switchValue': false,
    'isAutoIrrigation': false,},
  ];


    final levelDisplay = Center(
  child: Container(
    margin: EdgeInsets.only(top: 12),
  child: Text('${(waterLevel * 100).toStringAsFixed(0)}%', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)

  ),);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:  Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TitleDisplay,
            bottle,
            levelDisplay,
            Card(
                elevation: 4.0,
                child :Padding(
                    padding: const EdgeInsets.all(1.0),
                    child : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Image.asset(items[0]['imageUrl']),
                          title: Text(items[0]['title']),
                          subtitle: Text(items[0]['subtitle']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Switch(
                                value: iSwitched,
                                onChanged: (bool value) {
                                  setState(() {
                                    print(value);
                                    iSwitched = value;
                                  });
                                },
                              ),

                            ],
                          ),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[

                            SizedBox(
                              width: 10,
                            ), //SizedBox
                            Text(
                              'Auto start ',
                              style: TextStyle(fontSize: 17.0),
                            ), //Text
                            SizedBox(width: 10), //SizedBox
                            /** Checkbox Widget **/
                            Checkbox(
                              checkColor: Colors.white,
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),

                            const SizedBox(width: 30),

                          ],
                        ),],
                    )))

          ],
        ),
      ),
    );
  }
}