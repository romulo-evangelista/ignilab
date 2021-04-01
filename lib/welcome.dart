import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ignilab/side_menu.dart';
import 'package:ignilab/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_vaccine.dart';
import 'list_vaccines.dart';

class Welcome extends StatelessWidget {
  final CollectionReference vaccines =
      FirebaseFirestore.instance.collection('vaccines');

  final currentUserEmail = FirebaseAuth.instance.currentUser.email;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(
        userName: currentUserEmail,
      ),
      body: Stack(children: <Widget>[
        Container(
          color: Colors.white,
          width: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeVertical * 3,
                vertical: SizeConfig.blockSizeVertical * 8,
              ),
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Text(
                    "Olá, $currentUserEmail!",
                    style: TextStyle(
                      color: Color(0xFF533A71),
                      fontFamily: 'Fira Sans',
                      fontSize: 34,
                    ),
                  ),
                  ListVaccines(),
                ],
              ),
            ),
          ),
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 7,
        color: Color(0xFF533A71),
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
                icon: Icon(Icons.menu, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.share, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddVaccine()),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
        backgroundColor: Color(0xFF43B1BF),
      ),
    );
  }
}
