import 'package:dongstagram/models/firestore/user_model.dart';

String getNewPostKey(UserModel userModel) =>
    "${DateTime.now().millisecondsSinceEpoch}_${userModel.userKey}"; // 조합해서 String 으로 반환
