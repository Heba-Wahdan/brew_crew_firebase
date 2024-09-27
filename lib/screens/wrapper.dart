import 'package:brew_crew/model/user.dart';
import 'package:brew_crew/screens/Authentication/authenticatiom.dart';
import 'package:brew_crew/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(
        context); //I need to use the provider.of because the users is already controlled by StreamProvider to get the user
    return user == null ? const AuthScreen() : HomeScreen();
  }
}
