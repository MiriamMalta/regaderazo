import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regaderazo/bloc/bloc/users_bloc.dart';
import 'package:regaderazo/data/leonor.dart';
import 'package:regaderazo/data/pedro.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../auth/user_auth_repository.dart';
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
  var general_index = -1;
  var queue = Queue<int>.from([0]); 
  var temp = null;

  List<dynamic> _profiles = [];

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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
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
                    child: _listProfiles(),
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
                    print("temp: $temp");
                    if (general_index < 0) {
                      ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(content: Text('No has seleccionado un perfil')),
                      );
                    }
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

  _listProfiles() {
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
            _profiles = data!['profiles'];
            for (int i = 0; i < _profiles.length; i++) 
              _profiles[i]['select'] = false;
            if (data != null) return _listProfiles2(data);
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _listProfiles2(Map<String, dynamic> data) {
    return Column(        
      children: [
        for (int i = 0; i < _profiles.length; i++)
          _character(
            _profiles[i],
            i,
          ),
        // get from firebase
        /* for (int i = 0; i < data['profiles'].length; i++)
          _character(
            data['profiles'][i],
            i + _profiles.length,
          ), */
      ],
    );
  }

  Widget _character(Map<String, dynamic> profile, int index) {
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
          color: profile['select'] == false ? ColorSelector.getGreyish() : ColorSelector.getPink(),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          "${profile['name']}",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _getColorFromHex(profile['color']),
          ),
        ),
      ),
    );
  }

  Color _getColorFromHex(String hexColor) {
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
    var initial;
    if (general_index >= 0) {
      initial = _profiles[general_index]["data"];
      if (initial == null) initial = 0.0;
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