import 'package:brew_crew/model/brew.dart';
import 'package:brew_crew/model/user.dart';
import 'package:brew_crew/screens/home/brew_list.dart';
import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    void _showSettingsPanel() {
      showModalBottomSheet(
          backgroundColor: const Color.fromARGB(255, 226, 218, 215),
          context: context,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: const SettingsForm(),
            );
          });
    }

    final user = Provider.of<Users?>(
        context); //I need to use the provider of because the users is already controlled by StreamProvider to get the user

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in!")),
      );
    }

    return StreamProvider<List<Brew>?>.value(
      value: DatabaseService(uid: user.uid).brews,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Brew crew",
            style: TextStyle(
                color: Color.fromARGB(255, 226, 218, 215), fontSize: 27),
          ),
          backgroundColor: const Color.fromARGB(255, 54, 46, 43),
          actions: [
            TextButton.icon(
              onPressed: () {
                _auth
                    .signOut(); // when I sign out it will return null so wrapper widget will return auth screen
              },
              label: const Text(
                "Log out",
                style: TextStyle(color: Color.fromARGB(255, 226, 218, 215)),
              ),
              icon: const Icon(
                Icons.person,
                color: Color.fromARGB(255, 226, 218, 215),
              ),
            ),
            IconButton(
                onPressed: () {
                  _showSettingsPanel();
                },
                icon: const Icon(
                  Icons.settings,
                  color: Color.fromARGB(255, 226, 218, 215),
                ))
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image:
                    AssetImage("assets/6a93dbeaf62944dd6e727ff85876a1ff.jpg"),
                fit: BoxFit.cover),
          ),
          child: const BrewList(),
        ),
      ),
    );
  }
}
