import 'package:dongstagram/models/camera_state.dart';
import 'package:dongstagram/models/gallery_state.dart';
import 'package:dongstagram/screens/profile_screen.dart';
import 'package:dongstagram/widgets/my_gallery.dart';
import 'package:dongstagram/widgets/take_photo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {

  CameraState _cameraState = CameraState();
  GalleryState _galleryState = GalleryState();

  @override
  // _CameraScreenState createState() => _CameraScreenState();
  _CameraScreenState createState() {
    _cameraState.getReadyToTakePhoto();         // 최대한 빨리 준비해준다.
    _galleryState.initProvider();
    return _CameraScreenState();
  }

}



class _CameraScreenState extends State<CameraScreen> {

  int _currentIndex = 1;
  PageController _pageController = PageController(initialPage: 1);
  String _title = 'Photo';

  @override
  void dispose() {
    _pageController.dispose();
    widget._cameraState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CameraState>.value(value: widget._cameraState),         // 아래도 같은 것인데 이렇게 실행한 이유는 위의 getReadyToTakePhoto를 미리 실행하기 위함이다.
        // ChangeNotifierProvider(create: (context) => CameraState()),
        ChangeNotifierProvider<GalleryState>.value(value: widget._galleryState),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            MyGallery(),
            TakePhoto(),
            Container(color: Colors.green,),
          ],
        onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
              switch(_currentIndex) {
                case 0:
                  _title = 'Gallery';
                  break;
                case 1:
                  _title = 'Photo';
                  break;
                case 2:
                  _title = 'Video';
                  break;
              }
            });
        },
        ),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 0,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
          currentIndex: _currentIndex,
          onTap: _onItemTabbed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.radio_button_checked),title: Text('GALLERY')),
            BottomNavigationBarItem(icon: Icon(Icons.camera),title: Text('PHOTO')),
            BottomNavigationBarItem(icon: Icon(Icons.video_call),title: Text('VIDEO')),
          ],
        ),
      ),
    );
  }

  void _onItemTabbed(index) {
        setState(() {
          _currentIndex = index;
          _pageController.animateToPage(_currentIndex, duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
        });
      }
}
