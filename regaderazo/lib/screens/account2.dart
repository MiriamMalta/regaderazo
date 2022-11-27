import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/user_auth_repository.dart';
import '../blocs/users/bloc/users_bloc.dart';
import '../config/colors.dart';
import '../models/temperature.dart';
import '../widgets/reusable/column_chart.dart';
import '../widgets/reusable/division.dart';
import '../widgets/shared/side_menu2.dart';
import 'home_page2.dart';

class Account2 extends StatefulWidget {
  Account2({
    Key? key,
    required List<Map<String, dynamic>> profiles,
  })  : _profiles = profiles,
        super(key: key);

  final List<Map<String, dynamic>> _profiles;

  @override
  State<Account2> createState() => _Account2State();
}

class _Account2State extends State<Account2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List _colors = [
    "0xFF000000",
    "0xFF5E548E",
    "0xFF9B90C2",
    "0xFF9F86C0",
    "0xFFA87DC2",
    "0xFFBE95C4",
    "0xFFE0B1CB",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideBar2(
        profiles: widget._profiles,
      ),
      body: Stack(
        children: [
          Container(
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
                                  pageBuilder: (context, animation1, animation2) => Account2(
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
                    _showFavorites(widget._profiles),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showFavorites(List<Map<String, dynamic>> profiles) {
    CollectionReference user = FirebaseFirestore.instance.collection('profile');
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
            if (data != null) {
              //_listSongs = data['favorites'];
              //print(_listSongs);
              //print(data['profiles']);
              if (data['profiles'].length == 0) return _empty("No hay perfiles en la cuenta");
              else return Container(
                child: Column(
                  children: [
                    _buildList(data['profiles'], profiles),
                  ],
                ),
              );
            };
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
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

  Container _buildList(List<dynamic> data, List<Map<String, dynamic>> profiles) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.width * 0.05,
        bottom: MediaQuery.of(context).size.width * 0.05,
      ),
      child: Column(
        children: [
          for (int j = 0; j < data.length; j++)
          for (int i = 0; i < profiles.length; i++)
            if (data[j]['name'] == profiles[i]['name'])
              _buildElement(data[j]),
        ]
      ),
    );
  }

  Widget _buildElement (Map<String, dynamic> profile) {
    var temp = profile['lastTemperature'];
    if (temp == null) temp = 0;
    else temp = profile['lastTemperature'].substring(0, 4);
    return Container(
      height: MediaQuery.of(context).size.height * 0.46,
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
                "${temp}ºC", // "${profile['lastTemperature']}ºC",
                style: TextStyle(
                  color: Color(int.parse(profile['color'])),
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
              ),
            ],
          ),
          Text("Tabla de temperaturas"),
          Container(
            child:
              _showTemperature(profile['name'], profile['color']),
              //_showTemperatures(profile),
              //_makeTempChart(profile['name'], profile['temperature']??[0]),
          ),
          _changeColor(profile['name']),
        ],
      ),
    );
  }

  Widget _changeColor (String name) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.05,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: <Widget> [
          for (int i = 0; i < _colors.length; i++)
            MaterialButton(
              color: Color(int.parse(_colors[i])),
              shape: CircleBorder(),
              onPressed: () {
                print('\x1B[34mColor: ${_colors[i]}\x1B[0m');
                BlocProvider.of<UsersBloc>(context).add(UserChangeColorEvent(profile: name, color: _colors[i]));
                /* Navigator.pushAndRemoveUntil(context, 
                  MaterialPageRoute(builder: (context) => Account()), (route) => false
                ); */
                Navigator.pushReplacement(
                  context, 
                  PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => Account2(
                        profiles: widget._profiles,
                      ),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  /* Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    print("HEX ${hexColor.length}");
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    else {
      return Colors.black;
    }
  } */

  /* _getTempInfo(String name) async {
    //BlocProvider.of<TemperatureBloc>(context).add(TemperatureGetEvent(profile: name));
    //getTemperature(name);
    Future<dynamic> temp = BlocProvider.of<TemperatureBloc>(context).getTemperature(name);
    print(temp);
  } */

  /* BlocConsumer<TemperatureBloc, TemperatureState> _showTemperatures(String name) {
    return BlocConsumer<TemperatureBloc, TemperatureState>(
      listener: (context, state) {
        if (state is TemperatureInitial) {
        }
        else if (state is TempErrorState) {
            ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          }
      },
      builder: (context, state) {
        print(state);
        if (state is TempChartState) {
          var _list = state.temp;
          print(_list);
          if (_list.length == 0) return _empty("No hay temperaturas en la cuenta");
          else return Container(
            /* child: Column(
              children: [
                //_listArea(),
              ],
            ), */
            child: Text(name)
          );
        }
        else {
          return _empty("No hay temperaturas en la cuenta");
        }
      },
    );
  } */

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
}