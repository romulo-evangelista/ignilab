import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/authentication_service.dart';

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
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
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.email, color: Colors.white),
                hintText: 'Digite seu Email',
                hintStyle: TextStyle(
                  color: Colors.white54,
                  fontFamily: 'OpenSans',
                )),
            controller: emailController,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Senha',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
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
          child: TextField(
            obscureText: true,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.lock, color: Colors.white),
                hintText: 'Digite seu Senha',
                hintStyle: TextStyle(
                  color: Colors.white54,
                  fontFamily: 'OpenSans',
                )),
            controller: passwordController,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordTF() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => print('botão pressionado - esqueci a senha'),
        child: Text(
          'Esqueceu sua senha?',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLoginBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.read<AuthenticationService>().signIn(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        child: Text(
          'ENTRAR',
          style: TextStyle(
              color: Color(0xFF527DAA),
              letterSpacing: 1.5,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans'),
        ),
      ),
    );
  }

  Widget _buildSignUpBtn() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        child: Text(
          'CADASTRE-SE',
          style: TextStyle(
              color: Color(0xFF527DAA),
              letterSpacing: 1.5,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans'),
        ),
      ),
    );
  }

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
              horizontal: 40.0,
              vertical: 120.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Entrar",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30.0),
                _buildEmailTF(),
                SizedBox(height: 30.0),
                _buildPasswordTF(),
                _buildForgotPasswordTF(),
                _buildLoginBtn(context),
                _buildSignUpBtn(),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
