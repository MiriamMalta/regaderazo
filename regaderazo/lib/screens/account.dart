import 'package:flutter/material.dart';

import '../config/colors.dart';
import '../data/piedad.dart';
import '../models/slean.dart';
import '../models/temperature.dart';
import '../widgets/reusable/column_chart.dart';
import '../widgets/reusable/division.dart';
import '../widgets/reusable/spline_area.dart';
import '../widgets/shared/side_menu.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final double temp = PiedadData().getTemperature().last['temperature'];
  final List<Map<String, dynamic>> data_1 = PiedadData().getTemperature();
  final List<Map<String, dynamic>> data_2 = PiedadData().getDay();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(
        //sideMenuColor: _primaryColor,
      ),
      body: Center(
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
                      onPressed: (){print("Home");}, 
                      icon: Icon(Icons.home), 
                      color: ColorSelector.getRed(),
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
                      child: Text('Regaderazo')
                    ),
                  ],
                ),
                Division(),
                Text(
                  "Temperatura",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  "${temp}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorSelector.getPurple(),
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
                SplineArea(data: _getSplineChart(), colorA: ColorSelector.getLightBlue(), colorB: ColorSelector.getPink()),
                SplineArea(data: _getSplineChart(), colorA: ColorSelector.getLightBlue(), colorB: ColorSelector.getPink()),
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

  _getSplineChart () {
    List<SplineAreaData> list = [];
    for(var i = 0; i < data_2.length; i++) {
      list.add(SplineAreaData(data_2[i]['day'], data_2[i]['saving'], data_2[i]['total']));
    }
    return list;
  }
}