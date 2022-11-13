import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:regaderazo/data/leonor.dart';
import 'package:regaderazo/data/pedro.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../config/colors.dart';
import '../data/clemente.dart';
import '../data/piedad.dart';
import '../data/leonor.dart';
import '../data/pedro.dart';
import '../widgets/reusable/division.dart';
import '../widgets/shared/side_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var slider = false;
  var general_index = 0;
  var queue = Queue<int>.from([0]); 

  List<Map<String, dynamic>> _profiles = [
    {
      "name": PiedadData().getName(),
      "color": PiedadData().getColor(),
      "select": false,
      "data": PiedadData().getTemperature().last['temperature'],
    },
    {
      "name": ClementeData().getName(),
      "color": ClementeData().getColor(),
      "select": false,
      "data": ClementeData().getTemperature().last['temperature'],
    },
    {
      "name": LeonorData().getName(),
      "color": LeonorData().getColor(),
      "select": false,
      "data": LeonorData().getTemperature().last['temperature'],
    },
    {
      "name": PedroData().getName(),
      "color": PedroData().getColor(),
      "select": false,
      "data": PedroData().getTemperature().last['temperature'],
    },
    {
      "name": PiedadData().getName(),
      "color": PiedadData().getColor(),
      "select": false,
      "data": PiedadData().getTemperature().last['temperature'],
    },
    {
      "name": ClementeData().getName(),
      "color": ClementeData().getColor(),
      "select": false,
      "data": ClementeData().getTemperature().last['temperature'],
    },
    {
      "name": LeonorData().getName(),
      "color": LeonorData().getColor(),
      "select": false,
      "data": LeonorData().getTemperature().last['temperature'],
    },
    {
      "name": PedroData().getName(),
      "color": PedroData().getColor(),
      "select": false,
      "data": PedroData().getTemperature().last['temperature'],
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
                      'Página Principal', 
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
                      child: Text('Cuentas')
                    ),
                  ],
                ),
                Division(),
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.03,
                    bottom: MediaQuery.of(context).size.width * 0.05,
                  ),
                  height: MediaQuery.of(context).size.width * 0.6,
                  child: SingleChildScrollView(
                    child: Column(        
                      children: [
                        for (int i = 0; i < _profiles.length; i++)
                          _character(
                            _profiles[i]['name'],
                            _profiles[i]['color'],
                            i,
                          ),
                      ],
                    ),
                  ),
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
                      child: Text('Iniciar')
                    ),
                  ],
                ),
                Division(),
                /* Stack(
                  fit: StackFit.loose,
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: (){
                        print("Start");
                      }, 
                      icon: Icon(Icons.opacity_sharp),
                      iconSize: MediaQuery.of(context).size.width * 0.75,
                      color: ColorSelector.getRBlue(),
                      splashRadius: MediaQuery.of(context).size.width * 0.4,
                    ),
                    Positioned(
                      top: slider == false ? MediaQuery.of(context).size.width * 0.35 : MediaQuery.of(context).size.width * 0.205,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: (){
                            print("display");
                            setState(() {
                              slider = !slider;
                            });
                          },
                          child: _slider ()
                        ),
                      ),
                    )
                  ],
                ) */
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.7,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: (){
                      print("display");
                      setState(() {
                        slider = !slider;
                      });
                    },
                    child: _slider2 ()
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _character(String name, Color color, int index) {
    return GestureDetector(
      onTap: (){
        setState(() {
          queue.add(index);
          if (queue.length > 1) {
            _profiles[queue.first]['select'] = false;
            queue.removeFirst();
          }
          _profiles[queue.last]['select'] = !_profiles[queue.last]['select'];
          if (_profiles[queue.last]['select'] == true) {
            general_index = queue.first;
            print(general_index);
          } 
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10, 
          horizontal: 20
        ),
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.02
        
        ),
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: _profiles[index]['select'] == false ? ColorSelector.getGreyish() : ColorSelector.getPink(),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          "$name",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color
          ),
        ),
      ),
    );
  }

  Widget _slider () {
    if (slider == true) {
      return SleekCircularSlider(
        min: -10.0,
        max: 50.0,
        initialValue: _profiles[0]["data"],
        appearance: CircularSliderAppearance(
          angleRange: 360,
          startAngle: 180,
          size: MediaQuery.of(context).size.width * 0.55,
        ),
        /* onChange: (double value) {
          print(value);
        }, */
        onChangeEnd: (double value) {
          print(value);
        },
        innerWidget: (double value) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              "${value.toStringAsFixed(1)}°C",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: ColorSelector.getRRed(),
              ),
            ),
          );
        },
      );
    }
    else {
      return Container(
        alignment: Alignment.center,
        child: Text(
          "${_profiles[0]["data"].toStringAsFixed(1)}°C",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: ColorSelector.getRRed(),
          ),
        ),
      );
    }
  }

  Widget _slider2 () {
    return SleekCircularSlider(
      min: -10.0,
      max: 50.0,
      initialValue: _profiles[general_index]["data"],
      appearance: CircularSliderAppearance(
        angleRange: 360,
        startAngle: 180,
        size: MediaQuery.of(context).size.width * 0.55,
      ),
      /* onChange: (double value) {
        print(value);
      }, */
      onChangeEnd: (double value) {
        print(value);
      },
      innerWidget: (double value) {
        return Container(
          alignment: Alignment.center,
          child: Text(
            "${value.toStringAsFixed(1)}°C",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: ColorSelector.getRRed(),
            ),
          ),
        );
      },
    );
  }


}