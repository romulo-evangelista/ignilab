import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'form_vaccine.dart';

Future<void> _deleteVaccine(CollectionReference vaccines, String id) {
  return vaccines.doc(id).delete();
}

class ListVaccines extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference vaccines =
        FirebaseFirestore.instance.collection('vaccines');

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

        return ListView(
          shrinkWrap: true,
          children: snapshot.data.docs.map((DocumentSnapshot document) {
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
                          document.data()['name'],
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
                          onPressed: () => {}
                          // MaterialPageRoute(
                          //     builder: (context) => FormVaccine(document.id)),
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
          }).toList(),
        );
      },
    );
  }
}
