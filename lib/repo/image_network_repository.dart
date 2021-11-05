import 'dart:io';

import 'package:dongstagram/repo/helper/image_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class ImageNetworkRepository {
  Future<TaskSnapshot?> uploadImage(File originImage, {required String postKey}) async{
    try {
      final File resized = await compute(getResizedImage, originImage);
      final Reference storageReference = FirebaseStorage.instance.ref().child(_getImagePathByPostKey(postKey));
      final UploadTask uploadTask = storageReference.putFile(resized);
      return uploadTask.onComplete;
    }catch(e){
        return null;
    }
  }

  String _getImagePathByPostKey(String postKey) => 'post/$postKey/post.jpg';

  Future<dynamic> getPostImageUrl(String postKey) {
    return FirebaseStorage.instance.ref().child(_getImagePathByPostKey(postKey)).getDownloadURL();
  }

}
ImageNetworkRepository imageNetworkRepository = ImageNetworkRepository();