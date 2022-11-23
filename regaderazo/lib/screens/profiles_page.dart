import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../auth/user_auth_repository.dart';
import '../blocs/users/bloc/users_bloc.dart';
import '../config/colors.dart';
import '../widgets/reusable/division.dart';
import '../widgets/shared/side_menu.dart';

class ProfilesPage extends StatefulWidget {
  const ProfilesPage({super.key});

  @override
  State<ProfilesPage> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends State<ProfilesPage> {
  var slider = false;
  var queue = Queue<int>.from([-1]); 
  var which = {};
  var temp = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: _listProfiles(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _listProfiles() {
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
        for (int i = 0; i < data['profiles'].length; i++)
          _character(
            data['profiles'][i],
            i,
          ),
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

}