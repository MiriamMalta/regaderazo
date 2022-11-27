import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../auth/user_auth_repository.dart';
import '../blocs/users/bloc/users_bloc.dart';
import '../config/colors.dart';
import '../widgets/reusable/division.dart';
import '../widgets/shared/side_menu2.dart';

class HomePage2 extends StatefulWidget {
  HomePage2({
    Key? key,
    required List<Map<String, dynamic>> profiles,
  })  : _profiles = profiles,
        super(key: key);

  final List<Map<String, dynamic>> _profiles;

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  var slider = false;
  var queue = Queue<int>.from([-1]); 
  var which = {};
  var temp = null;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print("INDIIIDE ${widget._profiles}");
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
                      'Regaderazo', 
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
                    child: _listProfiles(widget._profiles),
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
                  height: MediaQuery.of(context).size.width * 0.65,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        slider = !slider;
                      });
                    },
                    child: _slider2 ()
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print("index ${queue.first} temp: $temp");
                    if (queue.first < 0) {
                      ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(content: Text('No has seleccionado un perfil')),
                      );
                    }
                    if (temp == 0){
                      ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(content: Text('La temperatura es 0')),
                      );
                    }
                    if (queue.first > -1 && temp != null && temp != 0) {
                      BlocProvider.of<UsersBloc>(context).add(UsersAddTemperatureEvent(
                        profile: which['name'],
                        temperature: temp.toString(),
                      ));
                      ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(content: Text('Se ha iniciado el regaderazo con ${temp.toStringAsFixed(1)}°C')),
                      );
                    }
                    temp = null;
                  }, 
                  child: Text("Iniciar regadera")
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* BlocConsumer<UsersBloc, UsersState> _listProfiles() {
    return BlocConsumer<UsersBloc, UsersState>(
      listener: (context, state) {
        if (state is UsersErrorState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.error)),
            );
        }
      },
      builder: (context, state) {
        if (state is UsersLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is UsersAddState) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.profiles.length,
            itemBuilder: (context, index) {
              return _character(
                state.profiles[index].name,
                state.profiles[index].color,
                index,
              );
            },
          );
        } else {
          return Center(child: Text('No hay usuarios'));
        }
      },
    );
  } */

  _listProfiles(List<Map<String, dynamic>> profiles) {
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
    print(profiles.length);
    print(data['profiles'].length);
    return Column(        
      children: [
        /*for (int i = 0; i < _profiles.length; i++)
          _character(
            _profiles[i],
            i,
          ),
        */
        // get from firebase
        /* for (int i = 0; i < profiles.length; i++)
          for (int j = 0; j < data['profiles'].length; i++)
            //if (data['profiles'][j]['name'] == profiles[i]['name'])
              _character(
                data['profiles'][j],
                j,
              ), */
        for (int j = 0; j < data['profiles'].length; j++)
        for (int i = 0; i < profiles.length; i++)
        if (data['profiles'][j]['name'] == profiles[i]['name'])
          _character(
            data['profiles'][j],
            j,
          ),
        /* for (int i = 0; i < profiles.length; i++)
          _character(
            profiles[i],
            i,
          ), */
      ],
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
        width: MediaQuery.of(context).size.width * 0.8,
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
            color: Color(int.parse(profile['color'])),
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

  /* Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    else {
      return Colors.black;
    }
  } */

  /* Widget _slider () {
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
  } */

  Widget _slider2 () {
    var initial;
    if (queue.first >= 0) {
      try {
        initial = which["temperature"].last()["temperature"];
      } catch (e) {
        initial = 0.0;
      }
      temp = initial;
    }
    else {
      initial = 0.0;
    } 
    return SleekCircularSlider(
      min: -10.0,
      max: 50.0,
      initialValue: initial,
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
        temp = value;
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