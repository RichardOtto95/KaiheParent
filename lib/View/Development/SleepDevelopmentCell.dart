import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parent_side/model/globals.dart';
import '../../model/globals.dart' as global;
import 'package:charts_flutter/flutter.dart' as charts;

typedef DataToValue<T> = double Function(T item);
typedef DataToAxis<T> = String Function(int item);

class SleepDevelopmentCell extends StatefulWidget {
  @override
  _SleepDevelopmentCellState createState() => _SleepDevelopmentCellState();
}

class _SleepDevelopmentCellState extends State<SleepDevelopmentCell> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Container(
            decoration: BoxDecoration(
                color: global.SleepColor,
                borderRadius: new BorderRadius.circular(17.0)),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset("assets/sleep@2x.png", scale: 1.3),
                      SizedBox(width: 10),
                      Text(
                        "Descanso",
                        style: new TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: defaultPadding),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("1",
                                    style: TextStyle(
                                        fontSize: 44,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                Text("h",
                                    style: TextStyle(
                                        color: global.SleepTextColor,
                                        fontSize: 28)),
                                Text("03",
                                    style: TextStyle(
                                        fontSize: 44,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                Text("min",
                                    style: TextStyle(
                                        color: global.SleepTextColor,
                                        fontSize: 28)),
                              ]),
                          Text(
                            "Tempo médio de sono",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: defaultPadding),
                  Row(
                    children: [
                      Row(children: [
                        Container(
                            height: 20,
                            width: 20,
                            decoration: new BoxDecoration(
                              color: global.BathroomColor,
                              shape: BoxShape.circle,
                            ),
                            child: Text("  ")),
                        SizedBox(width: 10),
                        Text(
                          "Dormiu Bem",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      ]),
                      SizedBox(width: defaultPadding),
                      Row(children: [
                        Container(
                            height: 20,
                            width: 20,
                            decoration: new BoxDecoration(
                              color: global.HomeWorkColor,
                              shape: BoxShape.circle,
                            ),
                            child: Text("  ")),
                        SizedBox(width: 10),
                        Text(
                          "Dormiu Mal",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      ]),
                    ],
                  ),
                  SizedBox(height: defaultPadding),
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(flex: 8, child: SparkBar.withSampleData()),
                        Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("1 hora",
                                    style: TextStyle(color: Colors.white)),
                                Text("45 min",
                                    style: TextStyle(color: Colors.white)),
                                Text("30 min",
                                    style: TextStyle(color: Colors.white)),
                                Text("0 min",
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding,
                  )
                  // Padding(
                  //   padding: const EdgeInsets.only(top: defaultPadding + 5),
                  //   child: Row(
                  //     children: [
                  //       Text("Semana 1", style: TextStyle(color: Colors.white)),
                  //       Text("Semana 2", style: TextStyle(color: Colors.white)),
                  //       Text("Semana 3", style: TextStyle(color: Colors.white)),
                  //       Text("Semana 4", style: TextStyle(color: Colors.white))
                  //     ],
                  //   ),
                  // )
                ]))));
  }
}

class SparkBar extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SparkBar(this.seriesList, {this.animate});

  factory SparkBar.withSampleData() {
    return new SparkBar(
      _createSampleData(),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.BarRendererConfig(
          cornerStrategy: const charts.ConstCornerStrategy(10)),
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.NoneRenderSpec(),
          tickProviderSpec: new charts.StaticNumericTickProviderSpec(
            <charts.TickSpec<num>>[
              charts.TickSpec<num>(-2),
              charts.TickSpec<num>(30),
              charts.TickSpec<num>(45),
              charts.TickSpec<num>(60),
            ],
          )),
      // domainAxis: new charts.OrdinalAxisSpec(
      //     showAxisLine: false, renderSpec: new charts.NoneRenderSpec()),
      layoutConfig: new charts.LayoutConfig(
          leftMarginSpec: new charts.MarginSpec.fixedPixel(0),
          topMarginSpec: new charts.MarginSpec.fixedPixel(0),
          rightMarginSpec: new charts.MarginSpec.fixedPixel(0),
          bottomMarginSpec: new charts.MarginSpec.fixedPixel(0)),
    );
  }

  /// Create series list with single series
  static List<charts.Series<SleepTime, String>> _createSampleData() {
    final globalSalesData = [
      new SleepTime("1", 60, 1),
      new SleepTime("2", 45, 1),
      new SleepTime("3", 0, 2),
      new SleepTime("4", 45, 2),
      new SleepTime("5", 60, 1),
      new SleepTime("6", 45, 2),
      new SleepTime("7", 36, 1),
      new SleepTime("8", 25, 1),
      new SleepTime("9", 30, 2),
      new SleepTime("10", 45, 1),
      new SleepTime("11", 0, 1),
      new SleepTime("12", 60, 1),
      new SleepTime("13", 50, 1),
      new SleepTime("14", 39, 2),
      new SleepTime("15", 45, 2),
      new SleepTime("16", 30, 2),
    ];

    return [
      new charts.Series<SleepTime, String>(
        id: 'Global Revenue',
        domainFn: (SleepTime sales, _) => sales.day,
        measureFn: (SleepTime sales, _) => sales.hour,
        fillColorFn: (SleepTime sales, _) => sales.color == 1
            ? charts.Color(r: 117, g: 195, b: 181)
            : charts.Color(r: 246, g: 179, b: 30),
        data: globalSalesData,
      )
    ];
  }
}

/// Sample ordinal data type.
class SleepTime {
  final String day;
  final double hour;
  final int color;

  SleepTime(this.day, this.hour, this.color);
}
