import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dongstagram/constant/firestore_keys.dart';

class UserModel {
  final String userKey;
  final String profileImg;
  final String email;
  final List<dynamic> myPosts;
  final int followers;
  final List<dynamic> likedPosts;
  final String username;
  final List<dynamic> followings;
  final DocumentReference reference; // 해당 다큐먼트 위치를 저장해주는

  UserModel.fromMap(Map<String, dynamic>? map, this.userKey,        // 밑에 fromSnapshot에서 쓰기 위해
      {required this.reference})
      : profileImg = map![KEY_PROFILEIMG],
        username = map[KEY_USERNAME],
        email = map[KEY_EMAIL],
        likedPosts = map[KEY_LIKEDPOSTS],
        followers = map[KEY_FOLLOWERS],
        followings = map[KEY_FOLLOWINGS],
        myPosts = map[KEY_MYPOSTS];

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(                           // 위의 fromMap
      snapshot.data(),
      snapshot.id,
      reference: snapshot.reference
    );

  static Map<String, dynamic> getMapForCreateUser(String email) {
    // 다른곳에서 userModel을 안불러도  static이 있으면 다른 곳에서 사용가능하다.
    Map<String, dynamic> map = Map();
    map[KEY_PROFILEIMG] = "";
    map[KEY_USERNAME] = email.split("@")[0];
    map[KEY_EMAIL] = email;
    map[KEY_LIKEDPOSTS] = [];
    map[KEY_FOLLOWERS] = 0;
    map[KEY_FOLLOWINGS] = [];
    map[KEY_MYPOSTS] = [];
    return map;
  }

}
