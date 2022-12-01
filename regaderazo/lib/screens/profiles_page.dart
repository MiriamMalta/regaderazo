import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../auth/bloc/auth_bloc.dart';
import '../auth/user_auth_repository.dart';
import '../blocs/users/bloc/users_bloc.dart';
import '../config/colors.dart';
import '../widgets/reusable/division.dart';
import '../widgets/shared/old/side_menu.dart';
import 'old/home_page.dart';
import 'home_page2.dart';

class ProfilesPage extends StatefulWidget {
  @override
  State<ProfilesPage> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends State<ProfilesPage> {
  var slider = false;
  var queue = Queue<int>.from([-1]); 
  var which = {};
  var temp = null;

  TextEditingController _controller = TextEditingController();

  void _clearText() {
    _controller.clear();
    _admin.clear();
    _password.clear();
  }

  bool isChecked = false;
  TextEditingController _admin = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Stack(
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width * 0.4,
                          child: Image.asset(
                            'assets/regaderazo_logo.png',
                            width: MediaQuery.of(context).size.width * 0.3,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.03,
                            bottom: MediaQuery.of(context).size.width * 0.05,
                          ),
                          height: MediaQuery.of(context).size.width * 1.26,
                          child: SingleChildScrollView(
                            child: _listProfiles(context),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.035,
                right: MediaQuery.of(context).size.height * 0.035,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.height * 0.07,
                  child: FloatingActionButton(
                    heroTag: "btn1",
                    backgroundColor: ColorSelector.getRBlue(),
                    splashColor: ColorSelector.getRRed(),
                    onPressed: () {
                      _adminORnormal(context);
                    },
                    child: Icon(
                      //Icons.photo_camera_outlined,
                      Icons.add,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.height * 0.045,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.035,
                left: MediaQuery.of(context).size.height * 0.035,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.height * 0.07,
                  child: FloatingActionButton(
                    heroTag: "btn2",
                    backgroundColor: ColorSelector.getRRed(),
                    splashColor: ColorSelector.getRBlue(),
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                    },
                    child: Icon(
                      //Icons.photo_camera_outlined,
                      Icons.logout,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.height * 0.045,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.035,
                left: MediaQuery.of(context).size.width * 0.45,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.height * 0.07,
                  child: FloatingActionButton(
                    heroTag: "btn3",
                    backgroundColor: Colors.green,
                    splashColor: Colors.lightGreen,
                    onPressed: () {
                      print("reload");
                      Navigator.pushReplacement(
                        context, 
                        PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) => ProfilesPage(
                            ),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                    child: Icon(
                      //Icons.photo_camera_outlined,
                      Icons.replay,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.height * 0.045,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  _listProfiles(BuildContext context) {
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
            if (data != null) return _listProfiles2(data, context);
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _listProfiles2(Map<String, dynamic> data, BuildContext context) {
    return Column(        
      children: [
        for (int i = 0; i < data['profiles'].length; i++)
          _character(
            data['profiles'][i],
            i,
            context
          ),
      ],
    );
  }

  /* Widget _character(Map<String, dynamic> profile, int index, context) {
    return GestureDetector(
      onTap: (){
        /* setState(() {
          queue.add(index);
          which = profile;
          if (queue.length > 1) {
            queue.removeFirst();
          }
          print(queue);
          print(which['name']);
          if (profile['admin'] != null){
            _goTo(profile['admin'], context);
          }
        }); */
        if (profile['admin'] != null){
            _goTo(profile['admin'], context);
          }
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
          color: ColorSelector.getGreyish(),
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
  } */
  Widget _character(Map<String, dynamic> profile, int index, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.width * 0.01
      ),
      child: ElevatedButton(
        onPressed: () {
          print(profile['name']);
          _goToNormal(context, profile, false);
          /* if (profile['admin'] != null){
            _goTo(profile['admin'], context);
          } */
        }, 
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorSelector.getGreyish(), // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          padding: EdgeInsets.symmetric(
            vertical: 10, 
            horizontal: 20
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            "${profile['name']}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(int.parse(profile['color'])),
            )
          ),
        )
      ),
    );
  }

  /* Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  } */
  _goTo (Map<String, dynamic> admin, BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ir a cuenta admin"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Ingrese la contraseña"),
              TextField(
                controller: _password,
                decoration: InputDecoration(
                  hintText: "Contraseña de admin",
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearText;
                Navigator.of(context).pop();
              }, 
              child: Text("Cancelar")
            ),
            TextButton(
              onPressed: () {
                //print(_password.text);
                if (admin['admin'] == _password.text) {
                  //BlocProvider.of<UsersBloc>(context).add(UsersEventGoTo(profiles: which['name']));
                  print("admin $admin['admin'] vs password ${_password.text}");
                  _goToNormal(context, admin, true);
                } 
                else {
                  ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text('Contraseña incorrecta')),
                  );
                }
                _clearText;
                Navigator.of(context).pop();
              }, 
              child: Text("Aceptar")
            ),
          ],
        );
      }
    );
  }

  _goToAdmin(BuildContext context) {
    /* CollectionReference user = FirebaseFirestore.instance.collection('profile');
    user.doc(UserAuthRepository().getuid()).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['profiles'] != null) {
          print(data['profiles']);
        }
      },
      onError: (e) => print("Error getting document: $e"),
    ); */
    Navigator.pushReplacement(
      context, 
      PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => HomePage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  _goToNormal(BuildContext _context, Map<String, dynamic> name, bool admin) {
    CollectionReference user = FirebaseFirestore.instance.collection('profile');
    user.doc(UserAuthRepository().getuid()).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['profiles'] != null) {
          for (int i = 0; i < data['profiles'].length; i++) {
            if (data['profiles'][i]['admin'] == null && data['profiles'][i]['name'] == name['name']) {
              print("NORMAL ${data['profiles'][i]} ${data['profiles'][i].runtimeType}");
              Navigator.pushReplacement(
                context, 
                PageRouteBuilder(
                    pageBuilder: (_context, animation1, animation2) => HomePage2(
                      profiles: [data['profiles'][i]],
                    ),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                ),
              );
            }
            if (data['profiles'][i]['admin'] != null && data['profiles'][i]['name'] == name['name']) {
              print("ADMIN ${data['profiles']} ${data['profiles'].runtimeType}");
              if (admin) {
                List<Map<String, dynamic>> _profiles = [];
                for (var i = 0; i < data['profiles'].length; i++) {
                  print(data['profiles'][i]);
                  _profiles.add(data['profiles'][i] as Map<String, dynamic>);
                }
                print("${_profiles} ${_profiles.runtimeType}");
                Navigator.pushReplacement(
                  context, 
                  PageRouteBuilder(
                      pageBuilder: (_context, animation1, animation2) => HomePage2(
                        profiles: _profiles,
                      ),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                  ),
                );
              }
              else {
                _goTo(name, context);
              }
              /* List<Map<String, dynamic>> _profiles = [];
              for (var i = 0; i < data['profiles'].length; i++) {
                print(data['profiles'][i]);
                _profiles.add(data['profiles'][i] as Map<String, dynamic>);
              }
              print("${_profiles} ${_profiles.runtimeType}");
              Navigator.pushReplacement(
                context, 
                PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => HomePage2(
                      profiles: _profiles,
                    ),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                ),
              ); */
            } 
          }
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  /* Navigator.pushReplacement(
      context, 
      PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => HomePage2(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
      ),
    ); */
  }

  _adminORnormal(context) {
    CollectionReference user = FirebaseFirestore.instance.collection('profile');
    user.doc(UserAuthRepository().getuid()).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        print(data['profiles']);
        if (data['profiles'].length == 0) {
          _showDialogAdmin(context);
        } else {
          _showDialogNormal(context);
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
    /* print("0 ${user.doc(UserAuthRepository().getuid()).get()}");
    user.doc(UserAuthRepository().getuid()).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if(documentSnapshot.data() == true){
          print("1 ${documentSnapshot.data()}");
        }else{
          print("2 ${documentSnapshot.data()}");
        }
      } else {
        print("NOPE");
      }
    }); */
  }

  _showDialogAdmin (context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Agregar cuenta"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("¿Desea agregar una nueva cuenta?"),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Nombre de la cuenta",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("El primer usuario que se registre será el administrador"),
              SizedBox(
                height: 10,
              ),
              Text(
                "Favor de ingresar la contraseña de este perfil",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              TextField(
                controller: _admin,
                decoration: InputDecoration(
                  hintText: "Contraseña",
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearText;
                Navigator.of(context).pop();
              }, 
              child: Text("Cancelar")
            ),
            TextButton(
              onPressed: () {
                print(_controller.text);
                print(_admin.text.runtimeType);
                BlocProvider.of<UsersBloc>(context).add(UsersEventCreateTo(profiles: _controller.text, admin: _admin.text));
                _clearText;
                Navigator.of(context).pop();
                /* Navigator.pushReplacement(
                  context, 
                  PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => ProfilesPage(
                      ),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                  ),
                ); */
              }, 
              child: Text("Aceptar")
            ),
            /* TextButton(
              onPressed: () {
                print(_controller.text);
                print(_admin.text.runtimeType);
                BlocProvider.of<UsersBloc>(context).add(UsersEventCreateTo(profiles: _controller.text, admin: _admin.text));
                _clearText;
                Navigator.of(context).pop();
              }, 
              child: Text("Aceptar")
            ), */
          ],
        );
      }
    );
  }

  _showDialogNormal (context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Agregar cuenta"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("¿Desea agregar una nueva cuenta?"),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Nombre de la cuenta",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearText;
                Navigator.of(context).pop();
              }, 
              child: Text("Cancelar")
            ),
            TextButton(
              onPressed: () {
                print(_controller.text);
                BlocProvider.of<UsersBloc>(context).add(UsersEventCreateTo(profiles: _controller.text, admin: ""));
                _clearText;
                Navigator.of(context).pop();
              }, 
              child: Text("Aceptar")
            ),
          ],
        );
      }
    );
  }
}