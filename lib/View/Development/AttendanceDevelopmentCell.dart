import 'dart:ui';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parent_side/model/globals.dart';
import '../../model/globals.dart' as global;

class AttendanceDevelopmentCell extends StatefulWidget {
  @override
  State<AttendanceDevelopmentCell> createState() =>
      _AttendanceDevelopmentCellState();
}

class _AttendanceDevelopmentCellState extends State<AttendanceDevelopmentCell> {
  List<AttendanceData> _chartData;
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
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Container(
          decoration: BoxDecoration(
              color: global.AttendanceColor,
              borderRadius: new BorderRadius.circular(17.0)),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "Chamada",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: defaultPadding),
                      Stack(
                        children: [
                          // Center(
                          //   child: CupertinoPicker(
                          //     itemExtent: 5,
                          //     children: [
                          //       attendanceCell("1"),
                          //     ],
                          //   ),
                          // ),
                          Column(
                            children: [
                              attendanceCell("1"),
                              attendanceCell("3"),
                              attendanceCell("1"),
                              attendanceCell("2"),
                              attendanceCell("1"),
                            ],
                          ),
                          Opacity(
                              opacity: 0.5,
                              child: Container(
                                  width: 160,
                                  height: 130,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: <Color>[
                                        AttendanceColor,
                                        Colors.transparent,
                                        Colors.transparent,
                                        AttendanceColor,
                                      ],
                                      stops: [
                                        0.2,
                                        0.2,
                                        0.8,
                                        0.8,
                                      ],
                                    ),
                                  )))
                        ],
                      )
                    ],
                  ),
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
                          BoxShadow(blurRadius: 8.0, color: AttendanceColor),
                        ]),
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: Stack(
                        children: [
                          SfCircularChart(
                            margin: EdgeInsets.all(0),
                            series: <CircularSeries>[
                              DoughnutSeries<AttendanceData, String>(
                                  onPointTap: (ChartPointDetails details) {
                                    setState(() {
                                      this.quantity =
                                          "${getChartData()[details.pointIndex].quantity}%";
                                      this.type =
                                          "${getChartData()[details.pointIndex].type}";
                                    });
                                  },
                                  radius: "150%",
                                  dataSource: _chartData,
                                  xValueMapper: (AttendanceData data, _) =>
                                      data.type,
                                  yValueMapper: (AttendanceData data, _) =>
                                      data.quantity,
                                  pointColorMapper: (AttendanceData data, _) =>
                                      data.color,
                                  pointRadiusMapper: (AttendanceData data, _) =>
                                      "95%"),
                            ],
                          ),
                          Center(
                            child: SizedBox(
                              height: 105,
                              width: 105,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AttendanceColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AttendanceShaddowColor,
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                ],
              ))),
    );
  }

  Row attendanceCell(type) {
    return Row(children: [
      Text("20/05", style: TextStyle(color: Colors.white, fontSize: 12)),
      Image.asset(getIcon(type), scale: 3),
      Text("Chegou atrasado",
          style: TextStyle(color: Colors.white, fontSize: 12))
    ]);
  }

  String getIcon(type) {
    return type == '1'
        ? 'assets/Bola_presente@2x.png'
        : type == '2'
            ? 'assets/Bola_Faltou@2x.png'
            : type == '3'
                ? 'assets/Bola_Atrasado@2x.png'
                : 'assets/Bola_SaiuCedo@2x.png';
  }

  List<AttendanceData> getChartData() {
    final List<AttendanceData> chartData = [
      AttendanceData("Presente", 70, Colors.green),
      AttendanceData("Chegou atrasado", 10, Colors.yellow),
      AttendanceData("Faltou", 20, Colors.red)
    ];
    return chartData;
  }
}

class AttendanceData {
  AttendanceData(this.type, this.quantity, [this.color]);
  final String type;
  final int quantity;
  final Color color;
}
