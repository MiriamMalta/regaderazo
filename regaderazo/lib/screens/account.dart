import 'package:flutter/material.dart';

import '../config/colors.dart';
import '../data/clemente.dart';
import '../data/leonor.dart';
import '../data/pedro.dart';
import '../data/piedad.dart';
import '../models/temperature.dart';
import '../widgets/reusable/column_chart.dart';
import '../widgets/reusable/division.dart';
import '../widgets/shared/side_menu.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  List<Map<String, dynamic>> _profiles = [
    {
      "name": PiedadData().getName(),
      "color": PiedadData().getColor(),
      "temperature": PiedadData().getTemperature().last['temperature'],
      "temp_data": PiedadData().getTemperature(),
      "day_data": PiedadData().getDay(),
      "month_data": PiedadData().getMonth(),
    },
    {
      "name": ClementeData().getName(),
      "color": ClementeData().getColor(),
      "temperature": ClementeData().getTemperature().last['temperature'],
      "temp_data": ClementeData().getTemperature(),
      "day_data": ClementeData().getDay(),
      "month_data": ClementeData().getMonth(),
    },
    {
      "name": LeonorData().getName(),
      "color": LeonorData().getColor(),
      "temperature": LeonorData().getTemperature().last['temperature'],
      "temp_data": LeonorData().getTemperature(),
      "day_data": LeonorData().getDay(),
      "month_data": LeonorData().getMonth(),
    },
    {
      "name": PedroData().getName(),
      "color": PedroData().getColor(),
      "temperature": PedroData().getTemperature().last['temperature'],
      "temp_data": PedroData().getTemperature(),
      "day_data": PedroData().getDay(),
      "month_data": PedroData().getMonth(),
    },
  ];

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
                      'Cuentas', 
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
                      child: Text('Mis Cuentas')
                    ),
                  ],
                ),
                Division(),
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.05,
                    bottom: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < _profiles.length; i++)
                      _buildProfile(_profiles[i]),
                    ]
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfile (Map<String, dynamic> profile) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.width * 0.05,
      ),
      child: Column(
        children: [
          Text(
            "${profile['name']}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Última temperatura: ",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                "${profile['temperature']}ºC",
                style: TextStyle(
                  color: profile['color'],
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
              ),
            ],
          ),
          Text("Tabla de temperaturas"),
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.9,
            child: ColumnChart(
              data: _getTempChart(profile['temp_data']),
              color: profile['color'],
            ),
          ),
        ],
      ),
    );
  }

  _getTempChart (List<Map<String, dynamic>> data ) {
    List<TemperatureChart> list = [];
    for(var i = 0; i < data.length; i++) {
      list.add(TemperatureChart(data[i]['day'], data[i]['temperature']));
    }
    return list;
  }
}