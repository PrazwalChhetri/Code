import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:review/constants/routes.dart';
import 'package:review/crud/add_restro.dart';
import 'package:review/firebase_options.dart';
import 'package:review/home.dart';
import 'package:review/page/edit_recipe.dart';
import 'package:review/views/loginView.dart';
import 'package:review/views/registerView.dart';
import 'package:review/views/verifyEmailView.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Review App',
    theme: ThemeData(
      primaryColor: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      recipeRoute: (context) => const RecipeUI(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      createRecipeRoute: (context) => CreateRecipe(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              return const RecipeUI();
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction { logout }

class RecipeUI extends StatefulWidget {
  const RecipeUI({super.key});

  @override
  State<RecipeUI> createState() => _RecipeUIState();
}

class _RecipeUIState extends State<RecipeUI> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MainScreen(),
    );
  }
}

Future clear({required String key}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.remove(key);
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                clear(key: 'name');
              },
              child: const Text('Log out'),
            ),
          ],
        );
      }).then((value) => value ?? false);
}
