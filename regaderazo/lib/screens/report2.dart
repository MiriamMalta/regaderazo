import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:regaderazo/data/piedad.dart';
import 'package:regaderazo/models/slean.dart';

import '../auth/user_auth_repository.dart';
import '../config/colors.dart';
import '../models/temperature.dart';
import '../widgets/reusable/spline_area.dart';
import '../widgets/reusable/column_chart.dart';
import '../widgets/reusable/division.dart';
import '../widgets/shared/side_menu2.dart';
import 'home_page2.dart';

class Report2 extends StatefulWidget {
  Report2({
    Key? key,
    required List<Map<String, dynamic>> profiles,
  })  : _profiles = profiles,
        super(key: key);

  final List<Map<String, dynamic>> _profiles;

  @override
  State<Report2> createState() => _Report2State();
}

class _Report2State extends State<Report2> {
  final double temp = PiedadData().getTemperature().last['temperature'];
  final List<Map<String, dynamic>> data_1 = PiedadData().getTemperature();
  final List<Map<String, dynamic>> data_2 = PiedadData().getDay();
  final List<Map<String, dynamic>> data_3 = PiedadData().getMonth();

  var slider = false;
  var queue = Queue<int>.from([-1]); 
  var which = {};

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideBar2(
        profiles: widget._profiles,
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    IconButton(
                      onPressed: (){
                        print("Side menu");
                        _scaffoldKey.currentState?.openDrawer();
                      }, 
                      icon: Icon(Icons.menu_open), 
                      color: ColorSelector.getRRed(),
                    ),
                    IconButton(
                      onPressed: (){
                        print("Home");
                        /* Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())); */
                        Navigator.pushReplacement(
                          context, 
                          PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => HomePage2(
                                profiles: widget._profiles,
                              ),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      }, 
                      icon: Icon(Icons.home), 
                      color: ColorSelector.getRRed(),
                    ),
                    IconButton(
                      onPressed: (){
                        print("Home");
                        Navigator.pushReplacement(
                          context, 
                          PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => Report2(
                                profiles: widget._profiles,
                              ),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      }, 
                      icon: Icon(Icons.replay), 
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
                _listProfiles(widget._profiles),
                //_showReport(),
                if (which.length == 0) _empty('No hay usuario seleccionado'),
                if (which.length != 0) _showReport(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _listProfiles(List<Map<String, dynamic>> profiles) {
    CollectionReference user = FirebaseFirestore.instance.collection('profile');
    //CollectionReference profile = user.doc('profile').collection('profile');
    return FutureBuilder<DocumentSnapshot>(
      future: user.doc(UserAuthRepository().getuid()).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
            //print(" data to read ${profile.doc(data!['profile']).get()}");
            if (data?['profiles'].length == 0) return Center(child: Text('No hay usuarios'));
            if (data != null) return _listProfiles2(data, profiles);
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _listProfiles2(Map<String, dynamic> data, List<Map<String, dynamic>> profiles) {
    return /* Column(        
      children: [
        for (int i = 0; i < data['profiles'].length; i++)
          _character(
            data['profiles'][i],
            i,
          ),
      ],
    ); */
    Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.075,
      alignment: Alignment.topCenter,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          for (int j = 0; j < data['profiles'].length; j++)
          for (int i = 0; i < profiles.length; i++)
          if (data['profiles'][j]['name'] == profiles[i]['name'])
            _character(
              data['profiles'][j],
              j,
            ),
        ],
      ),
    );
  }

  Widget _character(Map<String, dynamic> profile, int index) {
    return GestureDetector(
      onTap: (){
        setState(() {
          queue.add(index);
          which = profile;
          if (queue.length > 1) {
            queue.removeFirst();
          }
          print(queue);
          print(which['name']);
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
        //width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          color: _chooseColor(index),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          "${profile['name']}",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(int.parse(profile["color"])),
          ),
        ),
      ),
    );
  }

  Color _chooseColor(int index){
    if (index == queue.first) {
      return ColorSelector.getPink();
    } else {
      return ColorSelector.getGreyish();
    }
  }

  Container _empty(String text){
    return Container(
      //width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _showReport () {
    var temp = which['lastTemperature'];
    if (temp == null) temp = 0;
    else temp = which['lastTemperature'].substring(0, 4);
    return Container(
      child: Column (
        children: [
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
                color: Color(int.parse(which["color"])),
              ),
            ),
          ),
          _showTemperature(which['name'], which['color']),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.05,
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
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.05,
          ),
          //SplineArea(data: _getDayChart(), colorA: ColorSelector.getLightBlue(), colorB: ColorSelector.getPink()),
          //SplineArea(data: _getMonthChart(), colorA: ColorSelector.getLightBlue(), colorB: ColorSelector.getPink()),
        ],
      ),
    );
  }

  Widget _showTemperature(String profileName, String color) {
    CollectionReference user = FirebaseFirestore.instance.collection('profile').doc(UserAuthRepository().getuid()).collection('$profileName');
    List<Map<String, dynamic>> _templist = []; 
    return FutureBuilder<DocumentSnapshot>(
      future: user.doc('temperatures').get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
            if (data != null) {
              //print('\x1B[33m${data}\x1B[0m');
              //print('\x1B[31m${data['temperatures']}\x1B[0m');
              if (data['temperatures'].length == 0) return _empty("No hay temperaturas en la cuenta");
              else {
                for (var i = 0; i < data['temperatures'].length; i++) {
                  //print(data['temperatures'][i]);
                  _templist.add(data['temperatures'][i]);
                }
                print('\x1B[33m$profileName ${_templist}\x1B[0m');
                return Container(
                  child: Column(
                    children: [
                      _makeTempChart(color, _templist)
                    ],
                  ),
                );
              }
            };
          }
        }
        return _empty("No hay temperaturas en la cuenta");
      },
    );
  }

  _makeTempChart (String color, List<Map<String, dynamic>> temperature) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.9,
      child: ColumnChart(
        data: _getTempChart(temperature),
        color: Color(int.parse(color)), //_getColorFromHex(color)
      ),
    );
  }

  _getTempChart (List<Map<String, dynamic>> data ) {
    List<TemperatureChart> list = [];
    print('\x1B[31mlenght ${data.length}\x1B[0m');
    if (data.length >= 7) {
      for(var i = data.length - 7; i < data.length; i++) {
        String date = data[i]['date'];
        list.add(TemperatureChart(date.substring(8, 10), double.parse('${data[i]['temperature']}')));
      }
    }
    else {
      for(var i = 0; i < data.length; i++) {
        String date = data[i]['date'];
        //print(date.substring(8, 10));
        //print(double.parse('${data[i]['temperature']}'));
        list.add(TemperatureChart(date.substring(8, 10), double.parse('${data[i]['temperature']}')));
      }
    }
    return list;
  }

  _getDayChart () {
    List<SplineAreaData> list = [];
    for(var i = data_2.length - 7; i < data_2.length; i++) {
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