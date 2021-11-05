import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraState extends ChangeNotifier {
  CameraController? _controller;
  CameraDescription? _cameraDescription;
  bool? _readyTakePhoto = false;

  void dispose() {
    if(_controller != null)
      _controller!.dispose();
    _controller = null;
    _cameraDescription = null;
    _readyTakePhoto = null;
    notifyListeners();
  }


  void getReadyToTakePhoto() async{
    List<CameraDescription> cameras = await availableCameras();

    if(cameras.isNotEmpty) {
      setCameraDescription(cameras[0]);
    }
    bool init = false;

    while(!init){
    init = await initialize();
    }
    _readyTakePhoto = true;
    notifyListeners();
  }

  void setCameraDescription(CameraDescription cameraDescription) {
    _cameraDescription = cameraDescription;
    _controller = CameraController(_cameraDescription, ResolutionPreset.medium);
  }

  Future<bool> initialize() async{
    try{
      await _controller!.initialize();    // 위의 initialize와는 다른것이다.   이것을 하다가 에러가 나면 true가 안나오고 catch구문으로 가서 false를 반환한다.
      return true;
    }catch(e) {
      return false;
    }
  }

  CameraController? get controller => _controller;
  CameraDescription? get description => _cameraDescription;
  bool? get isReadyToTakePhoto => _readyTakePhoto;
}