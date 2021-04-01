import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ignilab/size_config.dart';
import 'package:provider/provider.dart';
import 'package:ignilab/services/authentication_service.dart';

class SignUp extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

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

  Widget _buildEmailTF() {
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

  Widget _buildPasswordTF() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Digite uma senha para cadastrar';
        }
        return null;
      },
      obscureText: true,
      style: TextStyle(
          fontFamily: 'OpenSans', fontSize: SizeConfig.screenHeight / 40),
      decoration: InputDecoration(
        labelText: "Senha",
        labelStyle: TextStyle(color: Color(0xFF787878)),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        contentPadding: EdgeInsets.all(20),
      ),
      controller: passwordController,
    );
  }

  Widget _buildConfirmPasswordTF() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Confirme sua senha';
        }
        if (value != passwordController.text) {
          return 'As senhas não coincidem, por favor digite novamente';
        }
        return null;
      },
      obscureText: true,
      style: TextStyle(
          fontFamily: 'OpenSans', fontSize: SizeConfig.screenHeight / 40),
      decoration: InputDecoration(
        labelText: "Confirme sua senha",
        labelStyle: TextStyle(color: Color(0xFF787878)),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        contentPadding: EdgeInsets.all(20),
      ),
      controller: confirmPasswordController,
    );
  }

  Widget _buildNextBtn(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            var result = await context.read<AuthenticationService>().signIn(
                email: emailController.text.trim(),
                password: passwordController.text.trim());
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF43B1BF)),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
        ),
        child: Text(
          'PRÓXIMO',
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

  Widget _buildSignUpBtn(
    BuildContext context,
    TextEditingController name,
    TextEditingController lastName,
    TextEditingController email,
    GlobalKey<FormState> _formKey,
  ) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      return users
          .add({
            'name': name.text,
            'lastName': lastName.text,
            'email': email.text,
          })
          .then((value) => print("Vaccine Added"))
          .catchError((error) => print("Failed to add vaccine: $error"));
    }

    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            var result = await context.read<AuthenticationService>().signUp(
                email: emailController.text.trim(),
                password: passwordController.text.trim());

            if (result == 'Conta criada') {
              addUser();
              Navigator.pop(context);
            } else {
              print(result);
            }
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF43B1BF)),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
        ),
        child: Text(
          'CADASTRAR',
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

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color(0xFF533A71),
                  Color(0xFF43B1BF),
                ],
              ),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        child: Container(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: Image.asset('assets/Logo-letter.png'),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 15),
                  child: Text(
                    "Vamos começar com alguns dados básicos.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontFamily: "FiraSans",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 30),
            child: Form(
              key: _formKey,
              child: Stack(
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
                            _buildTextFieldTF("Sobrenome", lastNameController),
                            SizedBox(
                                height: SizeConfig.blockSizeHorizontal * 7),
                            _buildEmailTF(),
                            SizedBox(
                                height: SizeConfig.blockSizeHorizontal * 7),
                            _buildPasswordTF(),
                            SizedBox(
                                height: SizeConfig.blockSizeHorizontal * 7),
                            _buildConfirmPasswordTF(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 3),
                    alignment: Alignment.bottomCenter,
                    child: _buildSignUpBtn(
                      context,
                      nameController,
                      lastNameController,
                      emailController,
                      _formKey,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
