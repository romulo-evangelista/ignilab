import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ignilab/config/size_config.dart';
import 'package:ignilab/controller/invalid_login_controller.dart';
import 'package:ignilab/pages/auth/sign_up.dart';
import 'package:ignilab/services/authentication_service.dart';

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget _buildEmailTF() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) return 'Digite seu email para entrar';
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
        contentPadding: EdgeInsets.all(SizeConfig.screenHeight / 42),
      ),
      controller: emailController,
    );
  }

  Widget _buildPasswordTF() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Digite sua senha para entrar';
        }
        return null;
      },
      obscureText: true,
      style: TextStyle(fontFamily: 'OpenSans', fontSize: 18),
      decoration: InputDecoration(
        labelText: "Senha",
        labelStyle: TextStyle(color: Color(0xFF787878)),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        contentPadding: EdgeInsets.all(SizeConfig.screenHeight / 42),
      ),
      controller: passwordController,
    );
  }

  Widget _buildLoginBtn(BuildContext context, GlobalKey<FormState> _formKey,
      InvalidLoginController invalidLoginController) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            var result = await context.read<AuthenticationService>().signIn(
                email: emailController.text.trim(),
                password: passwordController.text.trim());

            if (result ==
                'There is no user record corresponding to this identifier. The user may have been deleted.') {
              invalidLoginController.changeInvalid(true);
            }
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF43B1BF)),
          padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.all(SizeConfig.screenHeight / 42)),
        ),
        child: Text(
          'LOGIN',
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

  Widget _buildRedirectSignUpPage(BuildContext context) {
    return Container(
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUp()),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
            side: MaterialStateProperty.all<BorderSide>(
              BorderSide(color: Color(0xFF43B1BF)),
            ),
            shadowColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: Text(
            'CRIE SUA CONTA AGORA',
            style: TextStyle(
              color: Color(0xFF43B1BF),
              letterSpacing: 1.25,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordTF() {
    return Container(
      child: TextButton(
        onPressed: () => print('botão pressionado - esqueci a senha'),
        child: Text(
          'Esqueceu sua senha?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: "FiraSans",
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            top: SizeConfig.screenHeight / 8,
            left: SizeConfig.screenHeight / 30,
            right: SizeConfig.screenHeight / 30,
          ),
          child: Column(
            children: [
              Container(
                child: Center(
                  child: Image.asset('assets/Logo-color.png'),
                ),
              ),
              Form(
                key: _formKey,
                child: Consumer<InvalidLoginController>(
                    builder: (context, invalidLoginController, widget) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: SizeConfig.screenHeight / 15),
                      _buildEmailTF(),
                      SizedBox(height: SizeConfig.screenHeight / 25),
                      _buildPasswordTF(),
                      SizedBox(height: SizeConfig.screenHeight / 25),
                      if (invalidLoginController.invalid)
                        Text(
                          'Login inválido! Verifique suas credenciais.',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      SizedBox(height: SizeConfig.screenHeight / 40),
                      _buildLoginBtn(context, _formKey, invalidLoginController),
                      SizedBox(height: SizeConfig.screenHeight / 50),
                      Text("Ainda não possui cadastro?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: "FiraSans",
                          )),
                      SizedBox(height: SizeConfig.screenHeight / 50),
                      _buildRedirectSignUpPage(context),
                      SizedBox(height: SizeConfig.screenHeight / 50),
                      _buildForgotPasswordTF(),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
