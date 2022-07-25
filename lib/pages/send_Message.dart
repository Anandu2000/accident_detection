import 'package:flutter/material.dart';
import 'package:accident_detection/calculations/locationcalculator.dart';
import 'package:accident_detection/calculations/locationload.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:accident_detection/pages/telegram_client.dart';
//import 'package:flutter_sms/flutter_sms.dart';
//import 'package:telephony/telephony.dart';

class SendMessage extends StatefulWidget {
  @override
  _SendMessageState createState() => _SendMessageState();
}


class _SendMessageState extends State<SendMessage> {

  late double long,lat;
  var type;
  late String address, locationmessage;
  String locOnly = '';
  String numbers = "8590636494";
  late LocationCalculator currLocation;
  final TelegramClient telegramClient = TelegramClient(
    chatId: "@flutter_project_eg",
    botToken: "5452255522:AAHeGqf4DlI6RiqpaUwtTBjUy0X0Z6jSdCQ",
  );
  
  bool responseval = false;
  //final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    serviceEnabled();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    print(args);
    type = args;
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              responseval
                  ? Text(
                'Message Sent\nHelp is on the way',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                ),
              )
                  : Text(
                  'Sending Message',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              if(responseval)
                Text(locOnly),
              TextButton(
                  onPressed: (){
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                  },
                  child: Text('Exit')
              )
              /*locationmessage != null ? Text(locationmessage) : Text('Aquiring Location'),
              TextButton(
                child: Text("Get location"),
                onPressed: () {
                  getLocation();
                },
              ),
              TextButton(
                child: Text("Send Message"),
                onPressed: () {
                  //sendMsg();
                },
              ),*/
            ],
          ),
        )
    );
  }

  Future<void> serviceEnabled() async {
    bool servicestatus = await Geolocator.isLocationServiceEnabled();

    if(servicestatus){
      print("GPS service is enabled");
    }else{
      print("GPS service is disabled.");
    }

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

  Future<void> sendMsg() async {
    await launch('https://wa.me/918129527937?text=Hello');
  }

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    long = position.longitude;
    lat = position.latitude;
    print(position.latitude);
    print('$long, $lat');

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude
      );

      Placemark place = placemarks[0];

      setState(() {
        address = "${place.administrativeArea},${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
    //address = _getAddressFromLatLng(position);
    print('new ');
    print(address);
    currLocation = LocationCalculator(position);
    print(currLocation.convertDMS());
    locationmessage = await address + '\n' + currLocation.convertDMS();
    locOnly = locationmessage;
    String link = 'http://www.google.com/maps/place/$lat,$long';
    locationmessage = 'Warning User1 encountered a $type \nLocation:\n' + locationmessage +'\n' + link;
    final String message = "Hello";
    final response = await telegramClient.sendMessage(locationmessage);
    print('hellooooooooooooo');
    print(response.statusCode);
    if(response.statusCode == 200){
      setState(() {
        responseval = true;
      });
      
    }
  }

/*
  void _sendSMS(String message, String recipents) async {
    telephony.sendSms(
        to: recipents,
        message: message
    );
    /*
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);*/
  }*/

}



