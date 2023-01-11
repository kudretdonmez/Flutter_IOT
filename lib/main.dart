import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter IOT Project',
      home: HomePage(title: 'IOT WEATHER MONITOR'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseReference _dbref;
  var temp;
  var hum;

  @override
  void initState() {
    super.initState();
    _dbref = FirebaseDatabase.instance.ref();
    tempChange();
    humChange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        actions: const [
          Icon(Icons.ac_unit_sharp),
          Icon(Icons.device_thermostat_outlined),
          Icon(Icons.sunny),
        ],
        title: Text(
          widget.title,
          style: AppBarText.appBarText,
        ),
        backgroundColor: Colors.green,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        elevation: 10,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Text('Temperature is: $temp'),
            //Text('Humidity is: $hum'),
            SleekCircularSlider(
              appearance: CircularSliderAppearance(
                  customWidths: CustomSliderWidths(trackWidth: 4, progressBarWidth: 20, shadowWidth: 40),
                  customColors: CustomSliderColors(
                      //trackColor: HexColor('#ef6c00'),
                      //progressBarColor: HexColor('#ffb74d'),
                      //shadowColor: HexColor('#ffb74d'),
                      shadowMaxOpacity: 0.5, //);
                      shadowStep: 20),
                  infoProperties: InfoProperties(
                      bottomLabelStyle: const TextStyle(
                          //color: HexColor('#6DA100'),
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                      bottomLabelText: 'Temp.',
                      mainLabelStyle: const TextStyle(
                          //color: HexColor('#54826D'),
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600),
                      modifier: (double value) {
                        return '$temp ˚C';
                      }),
                  startAngle: 90,
                  angleRange: 360,
                  size: 200.0,
                  animationEnabled: true),
              min: 0,
              max: 50,
              initialValue: temp,
            ),
            const SizedBox(
              height: 50,
            ),
            SleekCircularSlider(
              appearance: CircularSliderAppearance(
                  customWidths: CustomSliderWidths(trackWidth: 4, progressBarWidth: 20, shadowWidth: 40),
                  customColors: CustomSliderColors(
                      //trackColor: HexColor('#0277bd'),
                      //progressBarColor: HexColor('#4FC3F7'),
                      //shadowColor: HexColor('#B2EBF2'),
                      shadowMaxOpacity: 0.5, //);
                      shadowStep: 20),
                  infoProperties: InfoProperties(
                      bottomLabelStyle: const TextStyle(
                          //color: HexColor('#6DA100'),
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                      bottomLabelText: 'Humidity.',
                      mainLabelStyle: const TextStyle(
                          //color: HexColor('#54826D'),
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600),
                      modifier: (double value) {
                        return '$hum %';
                      }),
                  startAngle: 90,
                  angleRange: 360,
                  size: 200.0,
                  animationEnabled: true),
              min: 0,
              max: 100,
              initialValue: hum,
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  void tempChange() {
    _dbref.child('bme280').child('Temperature').onValue.listen((DatabaseEvent event) {
      Object? data = event.snapshot.value;
      setState(() {
        temp = data;
      });
    });
  }

  void humChange() {
    _dbref.child('bme280').child('Humidity').onValue.listen((DatabaseEvent event) {
      Object? data = event.snapshot.value;
      setState(() {
        hum = data;
      });
    });
  }
}

class AppBarText {
  static TextStyle appBarText = TextStyle(
    fontSize: 25,
    color: Colors.blueGrey[800],
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );
}
