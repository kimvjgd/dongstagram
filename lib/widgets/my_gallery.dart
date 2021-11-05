import 'dart:io';
import 'dart:typed_data';

import 'package:dongstagram/models/gallery_state.dart';
import 'package:dongstagram/models/user_model_state.dart';
import 'package:dongstagram/repo/helper/generate_post_key.dart';
import 'package:dongstagram/screens/share_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:local_image_provider/device_image.dart';
import 'package:local_image_provider/local_image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class MyGallery extends StatefulWidget {
  const MyGallery({Key? key}) : super(key: key);

  @override
  _MyGalleryState createState() => _MyGalleryState();
}

class _MyGalleryState extends State<MyGallery> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GalleryState>(builder:
        (BuildContext? context, GalleryState? galleryState, Widget? child) {
      return GridView.count(
        crossAxisCount: 3,
        children: getImages(context!, galleryState!),
      );
    });
  }

  List<Widget> getImages(BuildContext context, GalleryState galleryState) {
    return galleryState.images!
        .map((localImage) => InkWell(
            onTap: () async {
              Uint8List bytes = await localImage.getScaledImageBytes(
                  galleryState.localImageProvider!, 0.3); // LocalImage -> Bytes
              try {
                final String postKey = getNewPostKey(Provider.of<UserModelState>(context, listen: false).userModel);

                File imageFile = File(postKey)
                  ..writeAsBytesSync(
                      bytes); // .. 은 생성된 파일에 method를 실행한다는 뜻이다. 그 파일에 return
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => SharePostScreen(imageFile, postKey: postKey,)));
              } catch (e) {}
            },
            child: Image(
              fit: BoxFit.cover,
              image: DeviceImage(localImage,scale: 0.1),
            )))
        .toList();
  }
}
