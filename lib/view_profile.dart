import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ignilab/size_config.dart';

Widget _buildProfileInfo(CollectionReference users, String currentUserEmail) {
  return StreamBuilder<QuerySnapshot>(
    stream: users.snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData) {
        var result = snapshot.data.docs.where((doc) {
          return doc.data()['email'] == currentUserEmail;
        });
        var resName = result
            .map((res) => res.data()['name'] + ' ' + res.data()['lastName'])
            .toString();
        var userName = resName.substring(1, resName.length - 1);

        var resGender = result.map((res) => res.data()['gender']).toString();
        var gender = resGender.substring(1, resGender.length - 1);

        return Container(
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.only(top: SizeConfig.screenHeight / 7),
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
                    userName,
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
                if (gender != 'null')
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          gender,
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
        );
      } else {
        return Container();
      }
    },
  );
}

class ViewProfile extends StatelessWidget {
  final currentUserEmail = FirebaseAuth.instance.currentUser.email;

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          color: Colors.white,
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7),
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
                    // EditProfile(currentUserEmail),
                  },
                ),
              ),
            ],
          ),
        ),
        _buildProfileInfo(users, currentUserEmail),
      ]),
    );
  }
}
