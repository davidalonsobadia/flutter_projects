import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 105, 172, 169)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<SalesData> chartData = [
    SalesData(DateTime(2010), 35),
    SalesData(DateTime(2011), 28),
    SalesData(DateTime(2012), 34),
    SalesData(DateTime(2013), 32),
    SalesData(DateTime(2014), 40)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My first graph',
              style: GoogleFonts.aBeeZee(
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                series: <ChartSeries>[
                  // Renders line chart
                  LineSeries<SalesData, DateTime>(
                      dataSource: chartData,
                      xValueMapper: (SalesData sales, _) => sales.year,
                      yValueMapper: (SalesData sales, _) => sales.sales)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final DateTime year;
  final double sales;
}
