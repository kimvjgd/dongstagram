import 'package:dongstagram/constant/auth_input_decor.dart';
import 'package:dongstagram/constant/common_size.dart';
import 'package:dongstagram/models/firebase_auth_state.dart';
import 'package:dongstagram/widgets/or_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>(); //칸 form의 상태를 저장해준다.

  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // auth_screen에서는 false 여기선 true이면 맨 밑의 위젯은 키보드가 올라와도 가만히 있고 얘네들은 딸려올라온다.
      body: Padding(
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
                cursorColor: Colors.black54,
                controller: _emailController,
                decoration: textInputDecor('Email'),
                validator: (text) {
                  if (text!.isNotEmpty && text.contains('@')) {
                    return null;
                  } else {
                    return '정확한 이메일 주소를 입력해주세요.';
                  }
                },
              ),
              SizedBox(
                height: common_xs_gap,
              ),
              TextFormField(
                controller: _pwController,
                cursorColor: Colors.black54,
                obscureText: true,
                decoration: textInputDecor('Password'),
                validator: (text) {
                  if (text!.isNotEmpty && text.length > 1) {
                    return null;
                  } else {
                    return '제대로 된 비밀번호를 입력하세요.';
                  }
                },
              ),
              FlatButton(
                onPressed: () {
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgotten Password',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(
                height: common_s_gap,
              ),
              _submitButton(context),
              SizedBox(
                height: common_s_gap,
              ),
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
      ),
    );
  }

  FlatButton _submitButton(BuildContext context) {
    return FlatButton(
      color: Colors.blue,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          Provider.of<FirebaseAuthState>(context, listen: false).login(context, email: _emailController.text, password: _pwController.text);
        } else {
          print('Validation Fail!!');
        }
      },
      child: Text(
        'Sign In',
        style: TextStyle(color: Colors.white),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
