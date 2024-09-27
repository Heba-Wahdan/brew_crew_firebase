import 'package:brew_crew/model/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  // ignore: unused_field
  String _enteredName = "";
  String _enteredSugar = "0";
  int _enteredStrength = 100;
  final List<String> sugars = ["0", "1", "2", "3", "4"];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Handle error scenario
          return Center(
            child: Text("Something went wrong: ${snapshot.error}"),
          );
        }

        if (snapshot.hasData) {
          // Add non-null assertion to userData
          final userData = snapshot.data!;

          return Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "Update your Brew",
                  style: TextStyle(
                      color: Color.fromARGB(255, 90, 63, 53),
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  initialValue:
                      userData.name, // Use userData safely with null check
                  decoration:
                      textInputDecoration.copyWith(label: const Text("Name")),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _enteredName = value;
                    });
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  value:
                      _enteredSugar, // You don't need ?? because it's always set
                  onChanged: (value) {
                    setState(() {
                      _enteredSugar = value as String;
                    });
                  },
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text("$sugar sugar(s)"),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 15),
                Slider(
                  value: _enteredStrength.toDouble(),
                  activeColor: Colors.brown[_enteredStrength],
                  inactiveColor: Colors.brown[_enteredStrength],
                  divisions: 8,
                  min: 100,
                  max: 900,
                  onChanged: (value) {
                    setState(() {
                      _enteredStrength = (value.round() / 100).round() * 100;
                    });
                  },
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      DatabaseService(uid: user.uid).updateUserData(
                          _enteredSugar, _enteredName, _enteredStrength);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Update",
                    style: TextStyle(
                        color: Color.fromARGB(255, 105, 74, 62), fontSize: 18),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Loading();
        }
      },
    );
  }
}
