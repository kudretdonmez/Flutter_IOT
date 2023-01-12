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
            SleekCircularSlider(
              appearance: CircularSliderAppearance(
                  customWidths: CustomSliderWidths(trackWidth: 4, progressBarWidth: 25),
                  customColors: CustomSliderColors(
                    shadowColor: Colors.grey,
                    trackColor: Colors.orangeAccent[700],
                    progressBarColor: Colors.amber,
                  ),
                  infoProperties: InfoProperties(
                      bottomLabelStyle:
                          TextStyle(color: Colors.greenAccent[700], fontSize: 20, fontWeight: FontWeight.w600),
                      bottomLabelText: 'Temp.',
                      mainLabelStyle: TextStyle(color: Colors.teal[700], fontSize: 30.0, fontWeight: FontWeight.w600),
                      modifier: (double value) {
                        return '$temp ˚C';
                      }),
                  startAngle: 90,
                  angleRange: 360,
                  size: 250.0,
                  animationEnabled: true),
              min: 0,
              max: 50,
              initialValue: temp,
            ),
            const SizedBox(
              height: 30,
            ),
            SleekCircularSlider(
              appearance: CircularSliderAppearance(
                  customWidths: CustomSliderWidths(trackWidth: 4, progressBarWidth: 25),
                  customColors: CustomSliderColors(
                    shadowColor: Colors.grey,
                    trackColor: Colors.indigo[900],
                    progressBarColor: Colors.blueAccent[400],
                  ),
                  infoProperties: InfoProperties(
                      bottomLabelStyle:
                          TextStyle(color: Colors.greenAccent[700], fontSize: 20, fontWeight: FontWeight.w600),
                      bottomLabelText: 'Humidity.',
                      mainLabelStyle: TextStyle(color: Colors.teal[700], fontSize: 30.0, fontWeight: FontWeight.w600),
                      modifier: (double value) {
                        return '$hum %';
                      }),
                  startAngle: 90,
                  angleRange: 360,
                  size: 250.0,
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
