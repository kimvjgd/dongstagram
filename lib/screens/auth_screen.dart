import 'package:dongstagram/widgets/sign_in_form.dart';
import 'package:dongstagram/widgets/sign_up_form.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  List<Widget> forms = [SignUpForm(), SignInForm()];
  int selectedForm = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드가 올라와도 해당화면이 줄어들지 않는다.
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: selectedForm,
              children: forms,
            ),
            Positioned(
              height: 45,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey)),
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      if (selectedForm == 0) {
                        // if(instance is class)  ==   instance가 class로 만든거야?
                        selectedForm = 1;
                      } else {
                        selectedForm = 0;
                      }
                    });
                  },
                  child: RichText(
                    text: TextSpan(
                        text: (selectedForm == 1)
                            ? 'Already have an account?   '
                            : 'Dont\'t have an account?   ',
                        style: TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                              text: (selectedForm == 1) ? 'Sign Up' : 'Sign In',
                              style: TextStyle(color: Colors.blue)),
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
