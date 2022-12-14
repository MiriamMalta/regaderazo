import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/user_auth_repository.dart';
import '../../../config/colors.dart';
import '../../../screens/old/account.dart';
import '../../../screens/old/home_page.dart';
import '../../../screens/numbers.dart';
import '../../../screens/profiles_page.dart';
import '../../../screens/old/report.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final _pagesNameList = [
    "Perfiles",
    "Inicio",
    "Reporte",
    "Cuentas",
    "Más números",
  ];
  final _iconsList = [
    Icons.face,
    Icons.home,
    Icons.analytics,
    Icons.account_box,
    Icons.auto_graph,
  ];
  List<Widget> _pagesList = [
    ProfilesPage(),
    HomePage(),
    Report(),
    Account(),
    Numbers(),
  ];

  static const HOME = '/home';
  static const REPORT = '/report';
  static const ACCOUNT = '/account';
  static const NUMBERS = '/numbers';
  static const PROFILES = '/profiles';
  static final _pages2 = {
    PROFILES: (context) => ProfilesPage(),
    HOME: (context) => HomePage(),
    REPORT: (context) => Report(),
    ACCOUNT: (context) => Account(),
    NUMBERS: (context) => Numbers(),
  };

  @override
  Widget build(BuildContext context) {
    CollectionReference user = FirebaseFirestore.instance.collection('user');
    return FutureBuilder<DocumentSnapshot>(
      future: user.doc(UserAuthRepository().getuid()).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic>? data =
                snapshot.data!.data() as Map<String, dynamic>?;
            if (data != null) return _buildSide(data);
          }
        }
        return _loading();
      },
    );
  }

  Container _loading() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Drawer(
        child: Center(child: CircularProgressIndicator())
      )
    );
  }

  Container _buildSide(data) {
    return Container(
    width: MediaQuery.of(context).size.width * 0.5,
    child: Drawer(
      child: ListView(
        children: [
          //Column(children: [_buildDrawerHeader(),],),
          DrawerHeader(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(data!['profilePicture']),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  data?['username'],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  data!['email'],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 15,
                    color: ColorSelector.getDarkGrey()
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ColorSelector.getGrey(),
                  width: 1,
                ),
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                for (int i = 0; i < _pagesNameList.length; i++)
                  ListTile(
                    leading: Icon(
                      _iconsList[i],
                    ),
                    title: Text(
                      _pagesNameList[i],
                    ),
                    onTap: () {
                      // setState(() {
                      //   _currentPageIndex = i;
                      // });
                      // go to the page
                      /* Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _pagesList[i],
                        ),
                      ); */
                      Navigator.pushReplacement(
                        context, 
                        PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) => _pagesList[i],
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                        ),
                      );
                      Navigator.pushNamed(context, _pages2.keys.toList()[i]);
                      Navigator.pop(context);
                      //Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
          /* ListTile(
            leading: Icon(Icons.home),
            title: Text('Inicio'),
            onTap: () => {
              Navigator.pushNamed(context, '/home'),
            },
          ),
          ListTile(
            leading: Icon(Icons.analytics),
            title: Text('Reporte'),
            onTap: () => {
              Navigator.pushNamed(context, '/report'),
            },
          ),
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text('Cuentas'),
            onTap: () => {
              Navigator.pushNamed(context, '/account'),
            },
          ), 
          ListTile(
            leading: Icon(Icons.auto_graph),
            title: Text('Más números'),
            onTap: () => {
              Navigator.of(context).pop()
            },
          ),*/
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Salir de cuenta'),
            onTap: () => {
              BlocProvider.of<AuthBloc>(context).add(SignOutEvent())
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.22,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
            onTap: () => {
              Navigator.of(context).pop()
            },
          ),
        ],
      ),
    ),
  );
  }

  Widget _buildDrawerHeader() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      color: Colors.amber,
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                'assets/regaderazo_sin.png',
                width: 48,
                height: 48,
              ),
              Column(
                children: [
                  Text(
                    "Libgloss",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}