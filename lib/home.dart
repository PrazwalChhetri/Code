import 'package:flutter/material.dart';
import 'package:review/constants/routes.dart';
import 'package:review/page/home/home_screen.dart';
import 'package:review/page/profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;
  final List<Widget> screens = [
    HomeScreen(),
    Profile(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            createRecipeRoute,
            (route) => false,
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: SizedBox(
              height: 60,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            setState(() {
                              currentScreen = HomeScreen();
                              currentTab = 0;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.dashboard,
                                color:
                                    currentTab == 0 ? Colors.blue : Colors.grey,
                              ),
                              Text('DashBoard',
                                  style: TextStyle(
                                      color: currentTab == 0
                                          ? Colors.blue
                                          : Colors.grey))
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            setState(() {
                              currentScreen = const Profile();
                              currentTab = 4;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                color:
                                    currentTab == 4 ? Colors.blue : Colors.grey,
                              ),
                              Text('Profile',
                                  style: TextStyle(
                                      color: currentTab == 4
                                          ? Colors.blue
                                          : Colors.grey))
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ))),
    );
  }
}
