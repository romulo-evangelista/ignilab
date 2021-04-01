import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ignilab/size_config.dart';
import 'edit_vaccine.dart';

Future<void> _deleteVaccine(CollectionReference vaccines, String id) {
  return vaccines.doc(id).delete();
}

class ListVaccines extends StatelessWidget {
  final currentUserEmail = FirebaseAuth.instance.currentUser.email;

  @override
  Widget build(BuildContext context) {
    CollectionReference vaccines =
        FirebaseFirestore.instance.collection('vaccines');

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

        var finded = snapshot.data.docs.where((doc) {
          return doc.data()['belongsTo'] == currentUserEmail;
        });

        if (finded.length > 0) {
          return ListView(
            shrinkWrap: true,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              if (currentUserEmail == document.data()['belongsTo']) {
                return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF6CA8F1),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(15),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text(
                              document.data()['vaccine'],
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Dose: " + document.data()['dose'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          flex: 5,
                        ),
                        Expanded(
                          child: TextButton(
                            child: Icon(Icons.edit, color: Colors.white),
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
                        Expanded(
                          child: TextButton(
                            child: Icon(Icons.delete, color: Colors.white),
                            onPressed: () async =>
                                _deleteVaccine(vaccines, document.id),
                          ),
                        )
                      ],
                    ));
              } else {
                return Container();
              }
            }).toList(),
          );
        } else {
          return Container(
            child: Column(
              children: <Widget>[
                Container(
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
