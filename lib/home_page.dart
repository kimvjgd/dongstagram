import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:dongstagram/constant/screen_size.dart';
import 'package:dongstagram/models/user_model_state.dart';
import 'package:dongstagram/screens/camera_screen.dart';
import 'package:dongstagram/screens/feed_screen.dart';
import 'package:dongstagram/screens/profile_screen.dart';
import 'package:dongstagram/screens/search_screen.dart';
import 'package:dongstagram/widgets/my_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BottomNavigationBarItem> btmNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
    BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
    BottomNavigationBarItem(icon: Icon(Icons.healing), label: ""),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: ""),
  ];

  int _selectedIndex = 0;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  static List<Widget> _screens = <Widget>[
    Consumer<UserModelState>(
      builder: (BuildContext context, UserModelState userModelState,
          Widget? child) {
        if (userModelState == null ||
            userModelState.userModel.followings.isEmpty)
          return MyProgressIndicator(containerSize: 300);
        else
          return FeedScreen(followings: userModelState.userModel.followings);
      },
    ),
    SearchScreen(),
    Container(
      color: Colors.lightGreenAccent,
    ),
    Container(
      color: Colors.cyanAccent,
    ),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    if (size == null) size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      key: _key,
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: btmNavItems,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black87,
        currentIndex: _selectedIndex,
        onTap: _onBtmItemClick,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
    );
  }

  void _onBtmItemClick(int index) {
    switch (index) {
      case 2:
        _openCamera();
        break;
      default:
        {
          setState(() {
            // 상태가 바꼈으니 다시 바꿔달라고 stful한테 말해
            _selectedIndex = index;
          });
        }
    }
  }

  void _openCamera() async {
    if (await checkIfPermissionGranted(context)) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CameraScreen()));
    } else {
      SnackBar snackBar = SnackBar(
        content: Text('사진, 파일, 마이크 접근을 허용해야합니다.'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            _key.currentState!.hideCurrentSnackBar();
            AppSettings.openAppSettings();
          },
        ),
      );
      _key.currentState!.showSnackBar(snackBar);
    }
  }

  Future<bool> checkIfPermissionGranted(BuildContext context) async {
    bool permitted = false;

    Map<Permission, PermissionStatus> status = await [
      // permissionStatus의 type은 ENUM
      Permission.camera,
      Permission.microphone,
      Platform.isIOS ? Permission.photos : Permission.storage
    ].request();

    status.forEach((permission, permissionStatus) {
      if (permissionStatus.isGranted) permitted = true;
    });
    return permitted;
  }
}
