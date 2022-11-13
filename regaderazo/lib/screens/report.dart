import 'package:flutter/material.dart';
import 'package:regaderazo/data/piedad.dart';
import 'package:regaderazo/models/slean.dart';

import '../config/colors.dart';
import '../models/temperature.dart';
import '../widgets/reusable/spline_area.dart';
import '../widgets/reusable/column_chart.dart';
import '../widgets/reusable/division.dart';
import '../widgets/shared/side_menu.dart';

class Report extends StatefulWidget {
  Report({
    Key? key,
  }) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final double temp = PiedadData().getTemperature().last['temperature'];
  final List<Map<String, dynamic>> data_1 = PiedadData().getTemperature();
  final List<Map<String, dynamic>> data_2 = PiedadData().getDay();
  final List<Map<String, dynamic>> data_3 = PiedadData().getMonth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(
        //sideMenuColor: _primaryColor,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.1,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: (){
                        print("Home");
                      }, 
                      icon: Icon(Icons.home), 
                      color: ColorSelector.getRRed(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Text(
                      'Reporte', 
                      style: TextStyle(
                        fontSize: 30, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      alignment: Alignment.center,
                      child: Text('Temperatura')
                    ),
                  ],
                ),
                Division(),
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.05,
                    bottom: MediaQuery.of(context).size.width * 0.01,
                  ),
                  child: Text(
                    "Temperatura",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.01,
                    bottom: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Text(
                    "${temp}ºC",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: ColorSelector.getPurple(),
                    ),
                  ),
                ),
                ColumnChart(
                  data: _getTempChart(),
                  color: ColorSelector.getPurple()
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      alignment: Alignment.center,
                      child: Text('Ahorro de Agua')
                    ),
                  ],
                ),
                Division(),
                SplineArea(data: _getDayChart(), colorA: ColorSelector.getLightBlue(), colorB: ColorSelector.getPink()),
                SplineArea(data: _getMonthChart(), colorA: ColorSelector.getLightBlue(), colorB: ColorSelector.getPink()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getTempChart () {
    List<TemperatureChart> list = [];
    for(var i = 0; i < data_1.length; i++) {
      list.add(TemperatureChart(data_1[i]['day'], data_1[i]['temperature']));
    }
    return list;
  }

  _getDayChart () {
    List<SplineAreaData> list = [];
    for(var i = 0; i < data_2.length; i++) {
      list.add(SplineAreaData(data_2[i]['day'], data_2[i]['saving'], data_2[i]['total']));
    }
    return list;
  }

  _getMonthChart () {
    List<SplineAreaData> list = [];
    for(var i = data_3.length - 6; i < data_3.length; i++) {
      list.add(SplineAreaData(data_3[i]['month'], data_3[i]['saving'], data_3[i]['total']));
    }
    return list;
  }
}