import 'package:flutter/material.dart';

import '../../config/colors.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
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
                    backgroundImage: NetworkImage(
                        'https://avatars.githubusercontent.com/u/1681236?v=4'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Piedad Vives',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'piedad_v@gmail.com',
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
            ListTile(
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
              onTap: () => {Navigator.of(context).pop()},
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () => {Navigator.of(context).pop()},
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