import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ignilab/size_config.dart';
import 'edit_vaccine.dart';

Widget imunized(CollectionReference users, String currentUserEmail) {
  return StreamBuilder<QuerySnapshot>(
    stream: users.snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData) {
        var result = snapshot.data.docs.where((doc) {
          return doc.data()['email'] == currentUserEmail;
        });
        var message = result
            .map((res) =>
                res.data()['gender'] == 'Feminino' ? 'IMUNIZADA' : 'IMUNIZADO')
            .toString();

        var text = message.substring(1, message.length - 1);

        return Text(
          text,
          style: TextStyle(
            fontFamily: "Fira Sans",
            color: Color(0xFF27AE60),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.25,
          ),
        );
      } else {
        return Container();
      }
    },
  );
}

class ListVaccines extends StatelessWidget {
  final currentUserEmail = FirebaseAuth.instance.currentUser.email;

  @override
  Widget build(BuildContext context) {
    CollectionReference vaccines =
        FirebaseFirestore.instance.collection('vaccines');

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    SizeConfig().init(context);

    return StreamBuilder<QuerySnapshot>(
      stream: vaccines.snapshots(),
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
          return doc.data()['belongsTo'] == currentUserEmail;
        });

        if (find.length > 0) {
          return Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: SizeConfig.screenHeight / 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              'Status de imunização',
                              style: TextStyle(
                                fontFamily: "Fira Sans",
                                color: Color(0xFF828282),
                                fontSize: 12,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 1),
                          Container(
                            padding:
                                EdgeInsets.all(SizeConfig.screenHeight / 100),
                            decoration: BoxDecoration(
                              color: Color(0xFFD4EFDF),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: imunized(users, currentUserEmail),
                          )
                        ],
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 3),
                      Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "ÚLTIMAS VACINAS",
                                style: TextStyle(
                                  fontFamily: "Fira Sans",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 1.5,
                                  color: Color(0xFF4F4F4F),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 1,
                                color: Color(0xFFBDBDBD),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    if (currentUserEmail == document.data()['belongsTo']) {
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      document.data()['vaccine'],
                                      style: TextStyle(
                                        fontFamily: 'Fira Sans',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      document
                                          .data()['manufacturer']
                                          .toString(),
                                      style: TextStyle(
                                        fontFamily: 'Fira Sans',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Doses',
                                              style: TextStyle(
                                                fontFamily: "Fira Sans",
                                                color: Color(0xFF828282),
                                                fontSize: 12,
                                                letterSpacing: 0.4,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              document
                                                  .data()['dose']
                                                  .toString(),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 70),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Data de aplicação',
                                              style: TextStyle(
                                                fontFamily: "Fira Sans",
                                                color: Color(0xFF828282),
                                                fontSize: 12,
                                                letterSpacing: 0.4,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              document
                                                  .data()['applicationDate'],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10, left: 5),
                                    child: TextButton(
                                      child: Text(
                                        "ATUALIZAR DOSAGEM",
                                        style:
                                            TextStyle(color: Color(0xFF6200EE)),
                                      ),
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditVaccine(
                                            document: document,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  }).toList(),
                ),
              ],
            ),
          );
        } else {
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.screenHeight / 10),
                  width: double.infinity,
                  height: SizeConfig.screenHeight / 3,
                  child: Image.asset('assets/Vaccines-placeholder.png'),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 5),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 70,
                  child: Text(
                    "Você ainda não informou nenhuma vacina." +
                        "\nQue tal fazer isso agora?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "FiraSans",
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 3),
                Text(
                  "Toque em + para adicionar uma vacina.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "FiraSans",
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
