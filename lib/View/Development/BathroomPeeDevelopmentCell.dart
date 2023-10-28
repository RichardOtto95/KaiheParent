import 'dart:ui';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parent_side/model/globals.dart';
import '../../model/globals.dart' as global;

class BathroomPeeDevelopmentCell extends StatefulWidget {
  @override
  State<BathroomPeeDevelopmentCell> createState() =>
      _BathroomPeeDevelopmentCellState();
}

class _BathroomPeeDevelopmentCellState
    extends State<BathroomPeeDevelopmentCell> {
  List<BathroomData> _chartData;
  String quantity = "";
  String type = "";

  @override
  void initState() {
    _chartData = getChartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, defaultPadding, 20, 0),
        child: Container(
            decoration: BoxDecoration(
                color: global.BathroomColor,
                borderRadius: new BorderRadius.circular(17.0)),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, defaultPadding, 0, 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Image.asset("assets/water@2x.png", scale: 1.3),
                            SizedBox(width: 10),
                            Text(
                              "Urinou",
                              style: new TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                          Row(children: [
                            Text("Média\npor dia",
                                style: TextStyle(color: Colors.white)),
                            SizedBox(width: 10),
                            Text("2",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 50)),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text("x",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold)),
                            )
                          ])
                        ],
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: -5,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                      color: Colors.black),
                                  BoxShadow(
                                      blurRadius: 8.0, color: BathroomColor),
                                ]),
                            child: SizedBox(
                              height: 150,
                              width: 150,
                              child: Stack(
                                children: [
                                  SfCircularChart(
                                    margin: EdgeInsets.all(0),
                                    series: <CircularSeries>[
                                      DoughnutSeries<BathroomData, String>(
                                          onPointTap:
                                              (ChartPointDetails details) {
                                            setState(() {
                                              this.quantity =
                                                  "${getChartData()[details.pointIndex].quantity}%";
                                              this.type =
                                                  "${getChartData()[details.pointIndex].type}";
                                            });
                                          },
                                          radius: "150%",
                                          dataSource: _chartData,
                                          xValueMapper:
                                              (BathroomData data, _) =>
                                                  data.type,
                                          yValueMapper:
                                              (BathroomData data, _) =>
                                                  data.quantity,
                                          pointColorMapper:
                                              (BathroomData data, _) =>
                                                  data.color,
                                          pointRadiusMapper:
                                              (BathroomData data, _) => "95%"),
                                    ],
                                  ),
                                  Center(
                                    child: SizedBox(
                                      height: 105,
                                      width: 105,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: BathroomColor,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: BathroomShaddowColor,
                                                blurRadius: 2.0,
                                                spreadRadius: 6.0,
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    bottom: defaultPadding,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: defaultPadding),
                                        Text(
                                          this.quantity.isEmpty
                                              ? "${getChartData()[0].quantity}%"
                                              : this.quantity,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35),
                                        ),
                                        Text(
                                            this.type.isEmpty
                                                ? "${getChartData()[0].type}"
                                                : this.type,
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
                          Column(
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
                                  "Na fralda",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ]),
                              SizedBox(height: 10),
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
                                  "No banheiro",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ]),
                              SizedBox(height: 10),
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
                                  "Na roupa",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ])
                            ],
                          ),
                        ]),
                  ],
                ))));
  }

  List<BathroomData> getChartData() {
    final List<BathroomData> chartData = [
      BathroomData("Na fralda", 22, global.AteAll),
      BathroomData("No banheiro", 33, global.AteHalf),
      BathroomData("Na roupa", 45, global.DidntEat)
    ];
    return chartData;
  }
}

class BathroomData {
  BathroomData(this.type, this.quantity, [this.color]);
  final String type;
  final int quantity;
  final Color color;
}
