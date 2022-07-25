import 'dart:async';
import 'package:accident_detection/pages/testPage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors/sensors.dart';
import 'package:accident_detection/calculations/abs_value.dart';
import 'package:accident_detection/widgets/drawerHeader.dart';
import 'package:accident_detection/calculations/homeArguments.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const int _snakeRows = 20;
  static const int _snakeColumns = 20;
  static const double _snakeCellSize = 10.0;
  double sound = 1.0;

  final List<String> names = <String>['Sujith', 'Amal', 'Rithul', 'Anandu'];
  final List<String> mobNumber = <String>[ '9495995852', '987642310', '6545557487', '9494945647', '9447535876'];

  TextEditingController nameController = TextEditingController();
  TextEditingController mobNumberController = TextEditingController();

  void addItemToList(){
    setState(() {
      names.insert(0,nameController.text);
      mobNumber.insert(0, mobNumberController.text);
    });
  }

  List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];
  late bool check_value;


  void gotowarning() async{
    var object = AbsValue(userAcceleration: _userAccelerometerValues);
    check_value = await object.check();
    //print(object.type);
    if(check_value){
      Navigator.pushNamed(
        context,
        '/warning',
        arguments: object.type
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String>? accelerometer =
    _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final List<String>? userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();


    return Scaffold(
      appBar: AppBar(
        title: const Text('ACCS'),
        backgroundColor: Colors.grey,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            createDrawerHeader(),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('Add Emergency Contacts'),
              onTap: (){
                Navigator.pushNamed(
                  context,
                  '/addContacts',
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.volume_up),
              title: Slider(
                value: sound,
                min: 0,
                max: 1,
                onChanged: (double newValue){
                  setState(() {
                    sound = newValue;
                    print(sound);
                  });
                },
              ),
              subtitle: Text('Alert Volume'),
            ),
            ListTile(
              leading: Icon(Icons.manage_accounts ),
              title: Text('Account Settings'),
            )
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Emergency Contacts',
              style: TextStyle(
                fontSize: 18,
                height: 2
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 50,),
                Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: names.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 50,
                            margin: EdgeInsets.all(2),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                color: index % 2 == 0 ? Colors.grey.shade200: Colors.grey.shade500,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 15,),
                                  Text('${names[index]}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(width: 2,)
                                ],
                              ),
                            ),
                          );
                        }
                    )
                ),
                SizedBox(width: 50,)
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.contact_phone),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/addContacts',
                    );
                  },
                  label: Text('Add'),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                    onPressed: (){
                      Navigator.pushNamed(
                        context,
                        '/warning',
                        arguments: 'anandu'
                      );
                    },
                    icon: Icon(Icons.warning),
                    color: Colors.grey,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
        gotowarning();
      });
    }));
  }


  Future<void> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      }else if(permission == LocationPermission.deniedForever){
        print("'Location permissions are permanently denied");
      }else{
        print("GPS Location service is granted");
      }
    }else{
      print("GPS Location permission granted.");
    }
  }


}
