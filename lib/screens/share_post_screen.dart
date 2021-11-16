import 'dart:io';

import 'package:dongstagram/constant/common_size.dart';
import 'package:dongstagram/constant/screen_size.dart';
import 'package:dongstagram/models/firestore/post_model.dart';
import 'package:dongstagram/models/firestore/user_model.dart';
import 'package:dongstagram/models/user_model_state.dart';
import 'package:dongstagram/repo/image_network_repository.dart';
import 'package:dongstagram/repo/post_network_repository.dart';
import 'package:dongstagram/widgets/my_progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:provider/provider.dart';

class SharePostScreen extends StatefulWidget {
  final File imageFile;
  final String postKey;

  const SharePostScreen(this.imageFile, {Key? key, required this.postKey})
      : super(key: key);

  @override
  _SharePostScreenState createState() => _SharePostScreenState();
}

class _SharePostScreenState extends State<SharePostScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  
  
  
  List<String> _tagItems = [
    'asd',
    'gsad',
    'eqwqweq',
    '123',
    'qwer',
    'adsf',
    'bzb',
    'jhgf',
    'kgf',
    'uy',
    '99090',
    'asd',
    'gsad',
    'eqwqweq',
    '123',
    'qwer',
    'adsf',
    'bzb',
    'jhgf',
    'kgf',
    'uy',
    '99090',
    'asd',
    'gsad',
    'eqwqweq',
    '123',
    'qwer',
    'adsf',
    'bzb',
    'jhgf',
    'kgf',
    'uy',
    '99090',
  ];
  
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New Post'),
          actions: <Widget>[
            FlatButton(
                onPressed: sharePostProcedure,
                child: Text(
                  'Share',
                  textScaleFactor: 1.4,
                  style: TextStyle(color: Colors.blue),
                )),
          ],
        ),
        body: ListView(
          children: [
            _captionWithImage(),
            _divider,
            _sectionButton('Tag People'),
            _divider,
            _sectionButton('Add Location'),
            _tags(),
            SizedBox(
              height: common_s_gap,
            ),
            _divider,
            SectionSwitch('Facebook'),
            SectionSwitch('Instagram'),
            SectionSwitch('Kakao'),
            _divider,
          ],
        ));
  }

  void sharePostProcedure() async {
    showModalBottomSheet(
        context: context,
        builder: (_) => MyProgressIndicator(containerSize: 200),
        isDismissible: false,
        enableDrag: false);
    print('여기까지는 되었는데');
    imageNetworkRepository
        .uploadImage(widget.imageFile, postKey: widget.postKey);

    UserModel usermodel = Provider.of<UserModelState>(context,listen: false).userModel;

    await postNetworkRepository.createNewPost(widget.postKey, PostModel.getMapForCreatePost(
        userKey: usermodel.userKey, username: usermodel.username, caption: _textEditingController.text));
    await Future.delayed(Duration(seconds: 3));
    String postImgLink = await imageNetworkRepository.getPostImageUrl(widget.postKey);
    await postNetworkRepository.updatePostImageUrl(postImg: postImgLink, postKey: widget.postKey);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  ListTile _captionWithImage() {
    return ListTile(
            contentPadding: EdgeInsets.symmetric(
                vertical: common_gap, horizontal: common_gap),
            leading: Image.file(widget.imageFile,
                width: size!.width / 6,
                height: size!.width / 6,
                fit: BoxFit.cover),
            title: TextField(
              controller: _textEditingController,
              autofocus: true,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Write a caption...',
                border: InputBorder.none,
              ),
            ),
          );
  }

  Tags _tags() {
    return Tags(
      horizontalScroll: true,
      itemCount: _tagItems.length,
      heightHorizontalScroll: 30,
      itemBuilder: (index) => ItemTags(
        index: index,
        title: _tagItems[index],
        activeColor: Colors.grey[200],
        textActiveColor: Colors.black87,
        borderRadius: BorderRadius.circular(4),
        elevation: 2,
        splashColor: Colors.grey[800],
        color: Colors.red,
      ),
    );
  }

  Divider get _divider => Divider(
        color: Colors.grey[300],
        thickness: 1,
        height: 1,
      );

  ListTile _sectionButton(String title) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
      trailing: Icon(Icons.navigate_next),
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: common_gap),
    );
  }
}

class SectionSwitch extends StatefulWidget {
  final String _title;

  const SectionSwitch(
    this._title, {
    Key? key,
  }) : super(key: key);

  @override
  _SectionSwitchState createState() => _SectionSwitchState();
}

class _SectionSwitchState extends State<SectionSwitch> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget._title,
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
      trailing: CupertinoSwitch(
        value: checked,
        onChanged: (onValue) {
          setState(() {
            checked = onValue;
          });
        },
      ),
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: common_gap),
    );
  }
}
