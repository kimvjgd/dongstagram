import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dongstagram/constant/common_size.dart';
import 'package:dongstagram/constant/screen_size.dart';
import 'package:dongstagram/models/camera_state.dart';
import 'package:dongstagram/models/user_model_state.dart';
import 'package:dongstagram/repo/helper/generate_post_key.dart';
import 'package:dongstagram/screens/share_post_screen.dart';
import 'package:dongstagram/widgets/my_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class TakePhoto extends StatefulWidget {

  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  Widget _progress = MyProgressIndicator(containerSize: 30);

  @override
  Widget build(BuildContext context) {
    return Consumer<CameraState>(builder:
        (BuildContext? context, CameraState? cameraState, Widget? child) {
      return Column(
        children: [
          Container(
            child: (cameraState!.isReadyToTakePhoto!) ? _getPreview(cameraState) : _progress,
            width: size!.width,
            height: size!.width,
            color: Colors.black,
          ),
          Expanded(
            child: OutlineButton(
              shape: CircleBorder(),
              borderSide: BorderSide(color: Colors.black12, width: 20),
              onPressed: () {
                if(cameraState.isReadyToTakePhoto!){
                  _attemptTakePhoto(cameraState, context!);
                }
              },
            ),
          )
        ],
      );
    });
  }

  Widget _getPreview(CameraState cameraState) {
    return ClipRect(
      child: OverflowBox(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Container(
                width: size!.width,
                height: size!.width / cameraState.controller!.value.aspectRatio,
                child: CameraPreview(cameraState.controller)),
          )),
    );
  }

  void _attemptTakePhoto(CameraState cameraState, BuildContext context) async{
    final String postKey = getNewPostKey(Provider.of<UserModelState>(context, listen: false).userModel);
    try{
      final path = join((await getTemporaryDirectory()).path, '$postKey.png');

      await cameraState.controller!.takePicture(path);
      File imageFile = File(path);
      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SharePostScreen(imageFile, postKey: postKey,)));
    }catch(e) {

    }
  }
}
