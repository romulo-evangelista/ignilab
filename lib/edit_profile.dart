import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ignilab/controller/gender_select_controller.dart';
import 'package:ignilab/size_config.dart';
import 'package:provider/provider.dart';

Widget _buildTextFieldTF(label, controller) {
  return TextFormField(
    validator: (value) {
      if (value.isEmpty) {
        return '$label não pode ser nulo';
      }
      return null;
    },
    style: TextStyle(fontFamily: 'OpenSans', fontSize: 18),
    decoration: InputDecoration(
      labelText: "$label",
      labelStyle: TextStyle(color: Color(0xFF787878)),
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
      ),
      contentPadding: EdgeInsets.all(20),
    ),
    controller: controller,
  );
}

Widget _buildEmailTF(TextEditingController emailController) {
  return TextFormField(
    validator: (value) {
      if (value.isEmpty) return 'Digite um email para cadastrar';
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value)) return 'Digite um email válido';

      return null;
    },
    keyboardType: TextInputType.emailAddress,
    style: TextStyle(fontFamily: 'OpenSans', fontSize: 18),
    decoration: InputDecoration(
      labelText: "Email",
      labelStyle: TextStyle(color: Color(0xFF787878)),
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
      ),
      contentPadding: EdgeInsets.all(20),
    ),
    controller: emailController,
  );
}

Widget _buildDropdownTF(String selected, Function selectChanged) {
  return DropdownButtonFormField(
    value: selected,
    onChanged: (value) {
      selectChanged(value);
    },
    items: <DropdownMenuItem>[
      DropdownMenuItem<String>(
          value: 'Feminino',
          child: Text(
            'Feminino',
            style: TextStyle(color: Color(0xFF787878)),
          )),
      DropdownMenuItem<String>(
          value: 'Masculino',
          child: Text(
            'Masculino',
            style: TextStyle(color: Color(0xFF787878)),
          )),
    ],
    style: TextStyle(fontFamily: 'OpenSans', fontSize: 18),
    decoration: InputDecoration(
      labelText: "Sexo",
      labelStyle: TextStyle(color: Color(0xFF787878)),
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
      ),
      contentPadding: EdgeInsets.all(20),
    ),
  );
}

class EditProfile extends StatelessWidget {
  final DocumentSnapshot document;

  EditProfile({this.document});

  Widget _buildEditProfileBtn(
      BuildContext context,
      String documentId,
      TextEditingController name,
      TextEditingController lastName,
      String gender,
      TextEditingController email,
      GlobalKey<FormState> _formKey) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> editUser(String userId) {
      return users
          .doc(documentId)
          .update({
            'name': name.text,
            'lastName': lastName.text,
            'gender': gender,
            'email': email.text,
          })
          .then((value) => {print("User Updated")})
          .catchError((error) => {print("Failed to update user: $error")});
    }

    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            editUser(documentId);
            Navigator.pop(context);
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF43B1BF)),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
        ),
        child: Text(
          'SALVAR ALTERAÇÕES',
          style: TextStyle(
            letterSpacing: 1.25,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final TextEditingController nameController =
        TextEditingController(text: document.data()['name']);
    final TextEditingController lastNameController =
        TextEditingController(text: document.data()['lastName']);
    final TextEditingController emailController =
        TextEditingController(text: document.data()['email']);

    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7),
            alignment: Alignment.topLeft,
            child: Row(
              children: <Widget>[
                Row(
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
                      "Editar perfil",
                      style: TextStyle(
                        color: Color(0xFF533A71),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.only(top: SizeConfig.screenHeight / 7),
            child: Form(
              key: _formKey,
              child: Consumer<GenderSelectController>(
                  builder: (context, genderSelectController, widget) {
                return Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 4,
                          left: SizeConfig.blockSizeVertical * 3,
                          right: SizeConfig.blockSizeVertical * 3,
                          bottom: SizeConfig.blockSizeVertical * 12,
                        ),
                        child: Container(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _buildTextFieldTF("Nome", nameController),
                              SizedBox(
                                  height: SizeConfig.blockSizeHorizontal * 7),
                              _buildTextFieldTF(
                                  "Sobrenome", lastNameController),
                              SizedBox(
                                  height: SizeConfig.blockSizeHorizontal * 7),
                              _buildDropdownTF(
                                document.data()['gender'] != null
                                    ? document.data()['gender']
                                    : genderSelectController.selected,
                                genderSelectController.changeGender,
                              ),
                              SizedBox(
                                  height: SizeConfig.blockSizeHorizontal * 7),
                              _buildEmailTF(emailController),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 3),
                      alignment: Alignment.bottomCenter,
                      child: _buildEditProfileBtn(
                        context,
                        document.id,
                        nameController,
                        lastNameController,
                        genderSelectController.selected,
                        emailController,
                        _formKey,
                      ),
                    )
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
