import 'package:dongstagram/constant/auth_input_decor.dart';
import 'package:dongstagram/constant/common_size.dart';
import 'package:dongstagram/home_page.dart';
import 'package:dongstagram/models/firebase_auth_state.dart';
import 'package:dongstagram/widgets/or_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  TextEditingController _cpwController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    _cpwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            SizedBox(
              height: common_l_gap,
            ),
            Image.asset('assets/images/insta_text_logo.png'),
            TextFormField(
              controller: _emailController,
              decoration: textInputDecor('Email'),
              cursorColor: Colors.black54,
              validator: (text) {
                if (text!.isNotEmpty && text.contains("@")) {
                  return null;
                } else {
                  return '정확한 이메일 주소를 입력하시오.';
                }
              },
            ),
            SizedBox(
              height: common_xs_gap,
            ),
            TextFormField(
              controller: _pwController,
              decoration: textInputDecor('Password'),
              cursorColor: Colors.black54,
              obscureText: true,
              validator: (text) {
                if (text!.isNotEmpty && text.length > 2) {
                  return null;
                } else {
                  return '정확한 비밀번를 입력하시오.';
                }
              },
            ),
            SizedBox(
              height: common_xs_gap,
            ),
            TextFormField(
              controller: _cpwController,
              cursorColor: Colors.black54,
              obscureText: true,
              decoration: textInputDecor('Confirm Password'),
              validator: (text) {
                if (text!.isNotEmpty && text == _pwController.text) {
                  return null;
                } else {
                  return '입력한 값이 비밀번호와 일치하지 않습니다.';
                }
              },
            ),
            SizedBox(height: common_s_gap,),
            _submitButton(context),
            SizedBox(height: common_s_gap,),
            OrDivider(),
            FlatButton.icon(
                onPressed: () {
                },
                textColor: Colors.blue,
                icon: ImageIcon(AssetImage('assets/images/facebook.png')),
                label: Text('Login with Facebook')),
          ],
        ),
      ),
    );
  }

  FlatButton _submitButton(BuildContext context) {
    return FlatButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Provider.of<FirebaseAuthState>(context, listen: false).registerUser(context, email: _emailController.text, password: _pwController.text);
              }
            },
            child: Text(
              'Sign Up',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          );
  }
}
