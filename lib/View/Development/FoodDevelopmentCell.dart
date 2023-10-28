import 'dart:ui';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parent_side/model/globals.dart';
import '../../model/globals.dart' as global;

class FoodDevelopmentCell extends StatefulWidget {
  @override
  State<FoodDevelopmentCell> createState() => _FoodDevelopmentCellState();
}

class _FoodDevelopmentCellState extends State<FoodDevelopmentCell> {
  List<FoodData> _chartData;

  @override
  void initState() {
    _chartData = getChartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Container(
            decoration: BoxDecoration(
                color: global.FoodColor,
                borderRadius: new BorderRadius.circular(17.0)),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset("assets/foodIcon@2x.png", scale: 1.3),
                        SizedBox(width: 10),
                        Text(
                          "Alimentação",
                          style: new TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Text(
                          "De todas as refeições",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        //Gráfico
                        SizedBox(width: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: defaultPadding),
                                child: SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Stack(
                                    children: [
                                      SfCircularChart(
                                        margin: EdgeInsets.all(0),
                                        series: <CircularSeries>[
                                          DoughnutSeries<FoodData, String>(
                                              onPointTap:
                                                  (ChartPointDetails details) {
                                                print(details.dataPoints[0]);
                                              },
                                              radius: "150%",
                                              dataSource: _chartData,
                                              xValueMapper:
                                                  (FoodData data, _) =>
                                                      data.type,
                                              yValueMapper:
                                                  (FoodData data, _) =>
                                                      data.quantity,
                                              pointColorMapper:
                                                  (FoodData data, _) =>
                                                      data.color,
                                              pointRadiusMapper:
                                                  (FoodData data, _) => "95%")
                                        ],
                                      ),
                                      Positioned.fill(
                                        bottom: defaultPadding,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: defaultPadding),
                                            Text(
                                              "50%",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 35),
                                            ),
                                            Text("Comeu tudo",
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Container(
                                          height: 20,
                                          width: 20,
                                          decoration: new BoxDecoration(
                                            color: global.AteAll,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text("  ")),
                                      SizedBox(width: 10),
                                      Text(
                                        "Comeu pouco",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                                    SizedBox(height: 4),
                                    Row(children: [
                                      Container(
                                          height: 20,
                                          width: 20,
                                          decoration: new BoxDecoration(
                                            color: global.AteHalf,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text("  ")),
                                      SizedBox(width: 10),
                                      Text(
                                        "Comeu metade",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                                    SizedBox(height: 4),
                                    Row(children: [
                                      Container(
                                          height: 20,
                                          width: 20,
                                          decoration: new BoxDecoration(
                                            color: global.DidntEat,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text("  ")),
                                      SizedBox(width: 10),
                                      Text(
                                        "Não comeu",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ])
                                  ],
                                ),
                              )
                            ]),
                        SizedBox(height: defaultPadding),
                        //Frequencia das refeições
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    "Frequência das refeições",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: defaultPadding),
                                Text(
                                  "Lanche da manhã",
                                  style: TextStyle(color: Colors.white),
                                ),
                                _buildProgressBar(context, 35),
                                SizedBox(height: defaultPadding),
                                Text(
                                  "Almoço:",
                                  style: TextStyle(color: Colors.white),
                                ),
                                _buildProgressBar(context, 100),
                                SizedBox(height: defaultPadding),
                                Text(
                                  "Lanche da tarde:",
                                  style: TextStyle(color: Colors.white),
                                ),
                                _buildProgressBar(context, 60),
                              ]),
                        ),
                      ],
                    )
                  ],
                ))));
  }

  Widget _buildProgressBar(BuildContext context, double progressvalue) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 4),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Stack(children: <Widget>[
          SfLinearGauge(
            orientation: LinearGaugeOrientation.horizontal,
            minimum: 0,
            maximum: 100,
            showTicks: false,
            showLabels: false,
            animateAxis: true,
            axisTrackStyle: LinearAxisTrackStyle(
              thickness: 0,
              edgeStyle: LinearEdgeStyle.bothCurve,
              borderWidth: 0,
              borderColor: Colors.white,
              color: FoodColor,
            ),
            barPointers: <LinearBarPointer>[
              LinearBarPointer(
                  position: LinearElementPosition.cross,
                  value: progressvalue,
                  thickness: 23,
                  edgeStyle: LinearEdgeStyle.bothCurve,
                  color: Colors.blue),
            ],
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 4, 10, 0),
                  child: Text(
                    progressvalue.toStringAsFixed(0) + '%',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ))),
        ]),
      ),
    );
  }

  List<FoodData> getChartData() {
    final List<FoodData> chartData = [
      FoodData("Comeu tudo", 22, global.AteAll),
      FoodData("Comeu metade", 33, global.AteHalf),
      FoodData("Não comeu", 45, global.DidntEat)
    ];
    return chartData;
  }
}

class FoodData {
  FoodData(this.type, this.quantity, [this.color]);
  final String type;
  final int quantity;
  final Color color;
}
