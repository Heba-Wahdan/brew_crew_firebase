// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';

import 'package:brew_crew/services/auth.dart';

class Register extends StatefulWidget {
  const Register({
    super.key,
    required this.toggleView,
  });
  final Function() toggleView;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  String _enteredEmail = "";
  String _enteredPassword = "";
  String error = "";
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              title: const Text(
                "Register to Brew crew",
                style: TextStyle(color: Color.fromARGB(255, 226, 218, 215)),
              ),
              backgroundColor: const Color.fromARGB(255, 54, 46, 43),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  label: const Text(
                    "Sign in",
                    style: TextStyle(color: Color.fromARGB(255, 226, 218, 215)),
                  ),
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "assets/6a93dbeaf62944dd6e727ff85876a1ff.jpg"),
                    fit: BoxFit.cover),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            return null; // Return null if the input is valid
                          },
                          decoration: textInputDecoration.copyWith(
                            label: const Text(
                              "Email",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _enteredEmail = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            } else if (value.length < 6) {
                              return "Password must be at least 6 characters long";
                            }
                            return null; // Return null if the input is valid
                          },
                          decoration: textInputDecoration.copyWith(
                            label: const Text(
                              "Password",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _enteredPassword = value;
                            });
                          },
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromARGB(255, 54, 46, 43)),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              dynamic result = await _auth.register(
                                  _enteredEmail, _enteredPassword);
                              if (result == null) {
                                setState(() {
                                  error = "Invalid Email and Password";
                                  isLoading = false;
                                });
                              }
                              // I do not have to write else to go to HomePage stream already does that
                            }
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                                color: Color.fromARGB(255, 226, 218, 215)),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          error,
                          style:
                              const TextStyle(fontSize: 15, color: Colors.red),
                        )
                      ],
                    )),
              ),
            ),
          );
  }
}
