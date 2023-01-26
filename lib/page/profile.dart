import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:review/constants/routes.dart';
import 'package:review/main.dart';
import 'package:review/page/singel_page.dart';
import 'package:review/page/edit_recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future dataa() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var data = preferences.getString('name');
  return data!;
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String inputData() {
    final User user = auth.currentUser!;
    final uid = user.email;
    return uid!;
  }

  Future clear({required String key}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('User Profile'),
      //   actions: [
      //     PopupMenuButton<MenuAction>(
      //       onSelected: (value) async {
      //         switch (value) {
      //           case MenuAction.logout:
      //             final shouldLogout = await showLogOutDialog(context);
      //             if (shouldLogout) {
      //               await FirebaseAuth.instance.signOut();
      //               Navigator.of(context).pushNamedAndRemoveUntil(
      //                 loginRoute,
      //                 (_) => false,
      //               );
      //             }
      //         }
      //       },
      //       itemBuilder: (context) {
      //         return const [
      //           PopupMenuItem<MenuAction>(
      //             value: MenuAction.logout,
      //             child: Text('Log out'),
      //           ),
      //         ];
      //       },
      //     )
      //   ],
      // ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    gradient: LinearGradient(colors: [
                      Colors.pink.withOpacity(0.6),
                      Colors.purple.withOpacity(0.4),
                      Colors.cyan.withOpacity(0.6)
                    ], begin: Alignment.bottomLeft, end: Alignment.topRight),
                  ),
                ),
                //image
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.25,
                  right: MediaQuery.of(context).size.width * 0.25,
                  top: 150,
                  child: CircleAvatar(
                    radius: 85,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage('assets/images/signup.png'),
                    ),
                  ),
                ),
                Positioned(
                  top: 330,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: Column(
                      children: [
                        //name
                        Container(
                          margin: EdgeInsets.all(20),
                          height: 30,
                          width: MediaQuery.of(context).size.width / 5,
                          child: FutureBuilder(
                              future: dataa(),
                              builder: (context, snapshot) {
                                return StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('Users')
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snap) {
                                      return SizedBox(
                                        height: 40,
                                        child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: snap.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              if (snapshot.data.toString() ==
                                                  snap.data!.docs[index]
                                                      ['email']) {
                                                return Text(
                                                  snap.data!.docs[index]['name']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.cyan),
                                                );
                                              } else {
                                                return SizedBox();
                                              }
                                            }),
                                      );
                                    });
                              }),
                        ),

                        //edit box
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: MaterialButton(
                            minWidth: 200,
                            height: 50,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            onPressed: () {},
                            child: Text('Edit Profile'),
                          ),
                        ),

                        //contaner

                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blueGrey),
                          child: Column(
                            children: [
                              buildListTile(
                                tap: () {},
                                text: 'Settings',
                                iconData: Icons.settings,
                              ),
                              buildListTile(
                                tap: () {},
                                text: 'Customer Support',
                                iconData: Icons.support_agent_rounded,
                              ),
                              buildListTile(
                                tap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text("Logout ?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(14),
                                            child: const Text("No"),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            // Navigator.of(ctx).pop();
                                            clear(key: 'name');
                                            await FirebaseAuth.instance
                                                .signOut();
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                              loginRoute,
                                              (_) => false,
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(14),
                                            child: const Text("yes"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                text: 'Sign Out',
                                iconData: Icons.logout,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Navigator.pushReplacementNamed(
                          //     context, MainScreen.routeName);
                        },
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }

  _showDialog(BuildContext context, {required String title}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Do you want to delete your receipe ? "),
          actions: [
            MaterialButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: Text("yes"),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('review')
                    .doc(title)
                    .delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

ListTile buildListTile(
    {required VoidCallback tap,
    required String text,
    required IconData iconData}) {
  return ListTile(
    leading: Icon(
      iconData,
      color: Colors.white,
    ),
    title: Text(
      text,
      style: TextStyle(color: Colors.white),
    ),
    trailing: IconButton(
      onPressed: tap,
      icon: Icon(
        Icons.arrow_forward_ios_sharp,
        color: Colors.white,
      ),
    ),
  );
}
