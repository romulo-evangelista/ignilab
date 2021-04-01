import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ignilab/size_config.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_vaccine.dart';
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
        style: TextStyle(color: Color(0xFF43B1BF), fontSize: 20),
      ),
    ),
  );
}

class Welcome extends StatelessWidget {
  final CollectionReference vaccines =
      FirebaseFirestore.instance.collection('vaccines');

  final currentUserEmail = FirebaseAuth.instance.currentUser.email;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeVertical * 3,
              vertical: SizeConfig.blockSizeVertical * 8,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Olá, $currentUserEmail!",
                  style: TextStyle(
                    color: Color(0xFF533A71),
                    fontFamily: 'Fira Sans',
                    fontSize: 34,
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 5),
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
                      padding: EdgeInsets.all(SizeConfig.screenHeight / 100),
                      decoration: BoxDecoration(
                        color: Color(0xFFD4EFDF),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Text(
                        'IMUNIZADA',
                        style: TextStyle(
                          fontFamily: "Fira Sans",
                          color: Color(0xFF27AE60),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.25,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 10),
                ListVaccines(),
              ],
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
                onPressed: () {},
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
