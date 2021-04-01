import 'package:flutter/material.dart';
import 'package:ignilab/services/authentication_service.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  String userName;

  SideMenu({this.userName});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      'assets/Logo.png',
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "$userName",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xFF43B1BF),
                  Color(0xFF533A71),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person_outlined,
              size: 35,
            ),
            title: Text(
              'Perfil',
              style: TextStyle(
                fontFamily: "Fira Sans",
                color: Color(0xFF828282),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(
              Icons.emoji_emotions_outlined,
              size: 35,
            ),
            title: Text(
              'Dê-nos seu feedback',
              style: TextStyle(
                fontFamily: "Fira Sans",
                color: Color(0xFF828282),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app_outlined,
              size: 35,
            ),
            title: Text(
              'Sair',
              style: TextStyle(
                fontFamily: "Fira Sans",
                color: Color(0xFF828282),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            onTap: () {
              context.read<AuthenticationService>().signOut();
            },
          ),
        ],
      ),
    );
  }
}
