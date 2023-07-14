import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class VanesScreen extends StatefulWidget {


  @override
  _VanesScreenState createState() => _VanesScreenState();
}

class _VanesScreenState extends State<VanesScreen> {
  final databaseReference = FirebaseDatabase.instance.ref().child('aquaflow/pumps/');



  List<Map<String, dynamic>> items = [
    {
      'imageUrl': 'assets/images/pump.png',
      'title': 'Pomp 1',
      'subtitle': 'Arroser le champ de maïs',
      'switchValue': false,
      'isAutoIrrigation': false,
    },
    {
      'imageUrl': 'assets/images/pump.png',
      'title': 'Pomp 2',
      'subtitle': 'Arroser le champ de fruits',
      'switchValue': false,
      'isAutoIrrigation': false,
    },
    {
      'imageUrl': 'assets/images/pump.png',
      'title': 'Pomp 3',
      'subtitle': 'Arroser le champ de tomates',
      'switchValue': false,
      'isAutoIrrigation': false,
    },
    {
      'imageUrl': 'assets/images/pump.png',
      'title': 'Pomp 4',
      'subtitle': 'Arroser le jardin',
      'switchValue': false,
      'isAutoIrrigation': false,
    },
  ];

  void _showConfigurationModal() {
    bool irrigationAuto = false; // added
    TimeOfDay startTime = TimeOfDay(hour: 0, minute: 0); // added
    TimeOfDay endTime = TimeOfDay(hour: 0, minute: 0); // added

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( // added
          builder: (context, setState) { // added
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Configuration',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  CheckboxListTile( // added
                    title: Text('Arrosage automatique'), // added
                    value: irrigationAuto, // added
                    onChanged: (value) { // added
                      setState(() {
                        irrigationAuto = value!;
                      });
                    },
                  ),
                  if (irrigationAuto) ...[ // added
                    ListTile( // added
                      leading: Icon(Icons.access_time), // added
                      title: Text('Heure de début'), // added
                      subtitle: Text('${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}'), // added
                      onTap: () async { // added
                        startTime = await showTimePicker( // added
                          context: context,
                          initialTime: startTime,
                        ) ?? startTime; // added
                        setState(() {}); // added
                      },
                    ),
                    ListTile( // added
                      leading: Icon(Icons.access_time), // added
                      title: Text('Heure de fin'), // added
                      subtitle: Text('${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}'), // added
                      onTap: () async { // added
                        endTime = await showTimePicker( // added
                          context: context,
                          initialTime: endTime,
                        ) ?? endTime; // added
                        setState(() {}); // added
                      },
                    ),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Annuler',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Enregistrer',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
              child: Card(
                  elevation: 4.0,
                  child :Padding(
                      padding: const EdgeInsets.all(16.0),
                      child : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Image.asset(items[index]['imageUrl']),
                            title: Text(items[index]['title']),
                            subtitle: Text(items[index]['subtitle']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Switch(
                                  value: items[index]['switchValue'],
                                  onChanged: (bool value) {
                                    setState(() {
                                      items[index]['switchValue'] = value;

                                      // Update the value of the pump in the database
                                      databaseReference.child('pump${index+1}').set(value);
                                    });
                                  },
                                ),

                              ],
                            ),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[

                              TextButton.icon(
                                onPressed:() => _showConfigurationModal(),
                                label: const Text('Configuration'),
                                icon: const Icon(Icons.settings),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white, backgroundColor: Colors.teal, disabledForegroundColor: Colors.grey.withOpacity(0.38),
                                ),
                              ),



                              const SizedBox(width: 30),

                            ],
                          ),],
                      ))));
        },
      ),
    );
  }
}


