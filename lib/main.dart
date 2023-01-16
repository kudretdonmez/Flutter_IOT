import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;

  late DatabaseReference _dbref;
  var temp;
  var hum;

  @override
  void initState() {
    super.initState();
    _dbref = FirebaseDatabase.instance.ref();
    tempChange();
    humChange();
    chartData = getChartData();
    Timer.periodic(const Duration(milliseconds: 500), updateDataSource);
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 0),
      LiveData(1, 0),
      LiveData(2, 0),
      LiveData(3, 0),
      LiveData(4, 0),
      LiveData(5, 0),
      LiveData(6, 0),
      LiveData(7, 0),
      LiveData(8, 0),
      LiveData(9, 0),
    ];
  }

  int time = 10;
  void updateDataSource(Timer timer) {
    chartData.add(LiveData(time++, temp));
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
      addedDataIndex: chartData.length - 1,
      removedDataIndex: 0,
    );
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
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 350,
              child: SfCartesianChart(
                legend: Legend(isVisible: true),
                series: [
                  LineSeries(
                    dataSource: chartData,
                    xValueMapper: (LiveData data, _) => data.time,
                    yValueMapper: (LiveData data, _) => data.temp,
                  )
                ],
                primaryXAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(width: 1),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  interval: 2,
                  title: AxisTitle(text: 'Time(seconds)'),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(width: 1),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  interval: 2,
                  title: AxisTitle(text: 'Temperature(Celcius)'),
                ),
              ),
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

class LiveData {
  final int time;
  var temp;

  LiveData(this.time, this.temp);
}
