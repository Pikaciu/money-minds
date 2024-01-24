import 'package:flutter/material.dart';
import 'package:money_minds/view/pages/learning_center.dart';
import 'package:money_minds/view/pages/parent_page.dart';
import 'package:money_minds/view/pages/profile_page.dart';
import 'package:money_minds/view/pages/profile_page_for_sidebar.dart';
import 'package:money_minds/view/pages/result_page.dart';

import '../../constants/color/color.dart';
import '../authentication/login/login_page.dart';
import 'courses.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({Key? key}) : super(key: key);
  @override
  _BottomNavigationBarScreenState createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  List? _pages;
  int? _selectedIndex = 0;

  @override
  void initState() {
    _pages = [
      const CoursesPage(),
      const LearningCenterPage(),
      // const MyLearningPage(),
      const ResultPage(),
      const ProfilePage()
    ];
    super.initState();
  }

  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Money Minds'),
        ),
        body: _pages![_selectedIndex!],
        bottomNavigationBar: BottomAppBar(
          child: BottomNavigationBar(
            // showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            backgroundColor: ColorConstants.appColor,
            onTap: _selectedPage,
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.grey.shade800,
            currentIndex: _selectedIndex!,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_stories_outlined),
                tooltip: 'Courses',
                label: 'Courses',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.play_circle),
                tooltip: 'Learning Center',
                label: 'Learning Center',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star_outline_sharp),
                tooltip: 'Result',
                label: 'Result',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                tooltip: 'User Account',
                label: 'Account',
              ),
            ],
          ),
        ),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 90,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Navigate to the home screen or perform desired action
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Parent'),
              onTap: () {
                // Navigate to the settings screen or perform desired action
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ParentPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Edit Profile'),
              onTap: () {
                // Navigate to the settings screen or perform desired action
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePageForSidebar()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Navigate to the settings screen or perform desired action
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
              },
            ),
          ],
        )));
  }
}
