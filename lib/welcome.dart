import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'form_vaccine.dart';
import 'list_vaccines.dart';
import 'services/authentication_service.dart';

Widget _buildLogoutBtn(BuildContext context) {
  return Container(
    alignment: Alignment.centerRight,
    child: TextButton(
      onPressed: () {
        context.read<AuthenticationService>().signOut();
      },
      child: Text(
        'Sair',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ),
  );
}

class Welcome extends StatelessWidget {
  final CollectionReference vaccines =
      FirebaseFirestore.instance.collection('vaccines');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF73AEF5),
                Color(0xFF61A4F1),
                Color(0xFF478DE0),
                Color(0xFF398AE5),
              ],
              stops: [0.1, 0.4, 0.7, 0.9],
            ),
          ),
        ),
        Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 80.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Vacinas",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildLogoutBtn(context),
                  ],
                ),
                SizedBox(height: 30.0),
                ListVaccines(),
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.all(30),
          child: FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FormVaccine()),
            ),
            child: Icon(
              Icons.add,
              color: Color(0xFF398AE5),
              size: 40,
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ]),
    );
  }
}
