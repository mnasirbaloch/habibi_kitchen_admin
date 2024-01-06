import 'package:flutter/material.dart';
import 'package:habibi_kitchen_admin/Providers/login_provider.dart';
import 'package:habibi_kitchen_admin/Screen/login_screen.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class LoginWrapper extends StatefulWidget {
  const LoginWrapper({super.key});

  @override
  State<LoginWrapper> createState() => _LoginWrapperState();
}

class _LoginWrapperState extends State<LoginWrapper> {
  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    loginProvider.getLoginInfoFromSharedPreferences();
   
    if (loginProvider.isUserLoggedIn == null ||
        loginProvider.isUserLoggedIn == false) {
      return const LoginScreenWidget();
    } else {
      return const HomeScreenWidget();
    }
  }
}
