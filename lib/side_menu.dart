import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ignilab/services/authentication_service.dart';
import 'package:provider/provider.dart';

Widget userNameText(CollectionReference users, String currentUserEmail) {
  return StreamBuilder<QuerySnapshot>(
    stream: users.snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData) {
        var result = snapshot.data.docs.where((doc) {
          return doc.data()['email'] == currentUserEmail;
        });
        var message = result
            .map((res) => res.data()['name'] + res.data()['lastName'])
            .toString();
        var welcome = message.substring(1, message.length - 1);

        return Text(
          welcome,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        );
      } else {
        return Container();
      }
    },
  );
}

class SideMenu extends StatelessWidget {
  final currentUserEmail = FirebaseAuth.instance.currentUser.email;

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

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
                    child: userNameText(users, currentUserEmail),
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
