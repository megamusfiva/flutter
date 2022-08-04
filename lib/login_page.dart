import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'User.dart';
import 'colors.dart';
import 'home_page.dart';


class LoginPage extends StatelessWidget{

  final TextEditingController emailUser = TextEditingController();
  final TextEditingController passUser = TextEditingController();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: VColor.primaryColors,
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Image.asset('assets/images/logo.png', scale: 3.0),
            const SizedBox(height: 50.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: VColor.black,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: emailUser,
                    style: const TextStyle(
                        fontSize: 14,
                        color: VColor.black
                    ),
                    decoration: InputDecoration(
                      focusColor: VColor.white,
                      prefixIcon: const Icon(
                        Icons.person_outline_rounded,
                        color: VColor.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: VColor.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Masukkan Username/Email",
                      hintStyle: const TextStyle(
                          color: VColor.grey,
                          fontSize: 14
                      ),
                    ),
                  ),
                ),

                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    obscureText: true,
                    controller: passUser,
                    style: const TextStyle(
                        fontSize: 16,
                        color: VColor.black
                    ),
                    decoration: InputDecoration(
                      focusColor: VColor.white,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: VColor.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: VColor.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      hintText: "Masukkan Password",
                      hintStyle: const TextStyle(
                          color: VColor.grey,
                          fontSize: 14
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Container(
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                  color: VColor.buttonColors, borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                onPressed: () {
                   login(context, emailUser.text, passUser.text);
                },
                child: const Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<User> login(BuildContext context, String email, String password) async {
  final response = await http.post(Uri.parse('https://reqres.in/api/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const HomePage()));
    return User.fromJson(jsonDecode(response.body));
  } else {
    _showMyDialog(context);
    throw Exception('Failed to login.');
  }
}

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Login Failed'),
        content: Container(
          child: Text('Please input the correct Username or Password'),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
