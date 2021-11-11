import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/view/home/homePage.dart';
import 'package:meetmeyou_app/view/settings/settingsPage.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Text('Calender Page',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
    Text('Add Page',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
    Text('Invite Friends Page',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
    SettingsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageView(
                path: ImageConstants.home_icon,
              ),
              activeIcon: ImageView(
                path: ImageConstants.home_icon_green,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageView(path: ImageConstants.calendar_icon),
              activeIcon: ImageView(
                path: ImageConstants.calendar_icon_green,
              ),
              label: 'Calender',
            ),
            BottomNavigationBarItem(
              icon: ImageView(path: ImageConstants.add_icon),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageView(path: ImageConstants.contacts_icon),
              activeIcon: ImageView(
                path: ImageConstants.contacts_icon_green,
              ),
              label: 'Invite Friends',
            ),
            BottomNavigationBarItem(
              icon: ImageView(path: ImageConstants.settings_icon),
              activeIcon: ImageView(
                path: ImageConstants.settings_icon_green,
              ),
              label: 'Settings',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: ColorConstants.colorWhite,
          currentIndex: _selectedIndex,
          selectedItemColor: ColorConstants.primaryColor,
          unselectedItemColor: ColorConstants.colorGray,
          iconSize: 25,
          onTap: _onItemTapped,
          elevation: 5,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}
