import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ignilab/config/size_config.dart';
import 'package:ignilab/pages/profile/edit_profile.dart';

class ViewProfile extends StatelessWidget {
  final currentUserEmail = FirebaseAuth.instance.currentUser.email;

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Houve um erro, tente novamente mais tarde!'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          print(snapshot);

          return Center(
            child: CircularProgressIndicator(),
          );
        }

        var find = snapshot.data.docs.where((doc) {
          return doc.data()['email'] == currentUserEmail;
        });

        if (find.length > 0) {
          return Scaffold(
            body: Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7),
              child: ListView(
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  if (currentUserEmail == document.data()['email']) {
                    return Stack(children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Container(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: Color(0xFF533A71),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Perfil",
                                    style: TextStyle(
                                      color: Color(0xFF533A71),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextButton(
                                child: Icon(
                                  Icons.edit,
                                  color: Color(0xFF533A71),
                                  size: 20,
                                ),
                                onPressed: () async => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                        document: document,
                                      ),
                                    ),
                                  ),
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 5),
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 3,
                            left: SizeConfig.blockSizeVertical * 3,
                            right: SizeConfig.blockSizeVertical * 3,
                            bottom: SizeConfig.blockSizeVertical * 16,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  document.data()['name'] +
                                      ' ' +
                                      document.data()['lastName'],
                                  style: TextStyle(
                                    color: Color(0xFF533A71),
                                    fontFamily: "Fira Sans",
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Email',
                                      style: TextStyle(
                                        fontFamily: "Fira Sans",
                                        color: Color(0xFF828282),
                                        fontSize: 12,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      currentUserEmail,
                                      style: TextStyle(
                                        fontFamily: "Fira Sans",
                                        fontSize: 16,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              if (document.data()['gender'] != null)
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Sexo',
                                        style: TextStyle(
                                          fontFamily: "Fira Sans",
                                          color: Color(0xFF828282),
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        document.data()['gender'],
                                        style: TextStyle(
                                          fontFamily: "Fira Sans",
                                          fontSize: 16,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ]);
                  } else {
                    return Container();
                  }
                }).toList(),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
