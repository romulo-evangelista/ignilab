import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ignilab/side_menu.dart';
import 'package:ignilab/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'add_vaccine.dart';
import 'list_vaccines.dart';

Future<void> _takeScreenshot(ScreenshotController _screenshotController) async {
  var imageFile = await _screenshotController.capture();
  Share.shareFiles([imageFile.path]);
}

Widget welcomeText(CollectionReference users, String currentUserEmail) {
  return StreamBuilder<QuerySnapshot>(
    stream: users.snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData) {
        var result = snapshot.data.docs.where((doc) {
          return doc.data()['email'] == currentUserEmail;
        });
        var message =
            result.map((res) => "Olá, " + res.data()['name'] + "!").toString();
        var welcome = message.substring(1, message.length - 1);

        return Text(
          welcome,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Color(0xFF533A71),
            fontFamily: 'Fira Sans',
            fontSize: 34,
          ),
        );
      } else {
        return Container();
      }
    },
  );
}

class Welcome extends StatelessWidget {
  final currentUserEmail = FirebaseAuth.instance.currentUser.email;

  final CollectionReference vaccines =
      FirebaseFirestore.instance.collection('vaccines');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      body: Stack(children: <Widget>[
        Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 8,
                      left: SizeConfig.blockSizeVertical * 3,
                      right: SizeConfig.blockSizeVertical * 3,
                    ),
                    width: double.infinity,
                    child: welcomeText(
                      users,
                      currentUserEmail,
                    ),
                  ),
                  Screenshot(
                    child: ListVaccines(),
                    controller: _screenshotController,
                  ),
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
                onPressed: () => _takeScreenshot(_screenshotController),
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
