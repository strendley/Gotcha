import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'screens/account-screen.dart';
import 'screens/account-settings-screen.dart';
import 'screens/add-user-screen.dart';
import 'screens/create-account-screen.dart';
import 'screens/forgot-password-screen.dart';
import 'screens/personal-info-screen.dart';
import 'screens/pictures-screen.dart';
import 'screens/pi-settings-screen.dart';
import './services/authentication.dart';
import 'widgets/widget-sign-in/sign-in.dart';
import 'helper.dart';
import 'widgets/widget-account/homepage.dart';
import 'widgets/widget-account/createAccount.dart';

/*
Route generate(RouteSettings settings){
  Route page;
}


void main() => runApp(Routes());

class Routes extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gothca App',
      theme: ThemeData(
          //primaryColor: Colors.blue,
          primaryColor: Color(0xff314C66)
      ),
      home:  SignIn(auth: new Auth()),
    );
  }
}
*/

/* Onboarding router */
Route onboardingRouter(RouteSettings settings) {
  Route page;
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(builder: (context)=> SignIn());
      break;
    case "/forgot-password":
      return MaterialPageRoute(builder: (context)=> ForgotPasswordPage());
      break;
    case "/create-account":
      return MaterialPageRoute(builder: (context)=> CreateAccount());
      break;
    default:
      return MaterialPageRoute(builder: (context)=> SignIn());
  }
  return page;
}

class Onboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  }
}