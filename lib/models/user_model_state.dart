import 'dart:async';

import 'package:dongstagram/models/firestore/user_model.dart';
import 'package:flutter/material.dart';


class UserModelState extends ChangeNotifier{
  UserModel? _userModel;
  StreamSubscription<UserModel>? _currentStreamSub;
  UserModel get userModel => _userModel!;

  set userModel(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }

  set currentStreamSub(StreamSubscription<UserModel> currentStreamSub) => _currentStreamSub = currentStreamSub;


  clear() async{
    if(_currentStreamSub != null)
      await _currentStreamSub!.cancel();
    _currentStreamSub = null;
    _userModel = null;
  }

  bool amIFollowingThisUser(String otherUserKey) {
    if(_userModel == null || _userModel!.followings.isEmpty) return false;
    return _userModel!.followings.contains(otherUserKey);
  }
}