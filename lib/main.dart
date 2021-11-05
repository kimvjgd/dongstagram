import 'dart:async';
import 'package:dongstagram/constant/material_white.dart';
import 'package:dongstagram/home_page.dart';
import 'package:dongstagram/models/firebase_auth_state.dart';
import 'package:dongstagram/models/firestore/user_model.dart';
import 'package:dongstagram/models/user_model_state.dart';
import 'package:dongstagram/repo/user_network_repository.dart';
import 'package:dongstagram/screens/auth_screen.dart';
import 'package:dongstagram/screens/profile_screen.dart';
import 'package:dongstagram/widgets/my_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAuthState _firebaseAuthState = FirebaseAuthState();
  Widget? _currentWidget;

  @override
  Widget build(BuildContext context) {
    _firebaseAuthState.watchAuthChange();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseAuthState>.value(
          value: _firebaseAuthState,
        ),
        ChangeNotifierProvider<UserModelState>(
          create: (_) => UserModelState(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: white,
        ),
        home: Consumer<FirebaseAuthState>(
          builder: (BuildContext context, FirebaseAuthState? firebaseAuthState,
              Widget? child) {
            switch (firebaseAuthState!.firebaseAuthStatus) {
              case FirebaseAuthStatus.signout:
                _clearUserModel(context);
                _currentWidget = AuthScreen();
                break;
              case FirebaseAuthStatus.signin:
                _initUserModel(firebaseAuthState, context);
                _currentWidget = HomePage();
                break;
              default:
                _currentWidget = MyProgressIndicator(containerSize: 30);
            }
            return AnimatedSwitcher(
              duration: duration,
              child: _currentWidget,
            );
          },
        ),
      ),
    );
  }

  void _initUserModel(FirebaseAuthState firebaseAuthState, BuildContext context) {

    UserModelState userModelState = Provider.of<UserModelState>(context, listen:false);

    userModelState.currentStreamSub = userNetworkRepository.getUserModelStream(firebaseAuthState.firebaseUser!.uid)
    .listen((userModel) {userModelState.userModel = userModel;});
  }

  void _clearUserModel(BuildContext context) {
    UserModelState userModelState = Provider.of<UserModelState>(context, listen: false);
    userModelState.clear();
  }

}
