import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:review/constants/routes.dart';
import 'package:review/home.dart';
import 'package:review/utilities/error_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController name;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    name = TextEditingController();
    super.initState();
  }

  Future writedata({required String email}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('name', email);
    print(" email stored      ============>>>>>>>>>>>>>" + email);
  }

  FirebaseFirestore storage = FirebaseFirestore.instance;
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Column(
        children: [
          TextField(
            controller: name,
            decoration: InputDecoration(hintText: 'Enter your User name'),
          ),
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter your Email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Enter your Password here'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                writedata(email: email);
                var user = await storage.collection('Users').doc(email);
                user.set({
                  'email': email,
                  'name': name.text,
                });
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (contexr) => MainScreen()));
              } catch (e) {
                await showErrorDialog(
                  context,
                  e.toString(),
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Already registered? Login here!'))
        ],
      ),
    );
  }
}
