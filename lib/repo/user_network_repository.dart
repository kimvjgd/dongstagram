import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dongstagram/constant/firestore_keys.dart';
import 'package:dongstagram/models/firestore/user_model.dart';
import 'package:dongstagram/repo/helper/transformer.dart';

class UserNetworkRepository with Transformers {
  Future<void> attemptCreateUser(
      {required String userKey, required String email}) async {
    final DocumentReference userRef =
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(userKey);

    DocumentSnapshot snapshot =
        await userRef.get(); // 기존에 userRef에 데이터가 있는지 확인하기 위해 일단 불러와본다.
    if (!snapshot.exists) {
      return await userRef.set(UserModel.getMapForCreateUser(email));
    }
  }

  Stream<UserModel> getUserModelStream(String userKey) {
    return FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .doc(userKey)
        .snapshots()
        .transform(toUser); //snapshots는 계속 user을 준다. snapshots의 type은 stream이다
    // transform DocumentSnapshot -> UserModel로 변경시켜준다.
  }

  Stream<List<UserModel>> getAllUsersWithoutMe() {
    return FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .snapshots()
        .transform(toUsersExceptMe);
  }

  Future<void> followUser(
      {required String myUserKey, required String otherUserKey}) async {
    final DocumentReference myUserRef =
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(myUserKey);
    final DocumentSnapshot mySnapshot = await myUserRef.get();
    final DocumentReference otherUserRef = FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .doc(otherUserKey);
    final DocumentSnapshot otherSnapshot = await otherUserRef.get();

    FirebaseFirestore.instance.runTransaction((tx) async {
      if (mySnapshot.exists && otherSnapshot.exists) {
        tx.update(myUserRef, {
          KEY_FOLLOWINGS: FieldValue.arrayUnion([otherUserKey])
        });
        int currentFollower = otherSnapshot.data()![KEY_FOLLOWERS];
        tx.update(otherUserRef, {KEY_FOLLOWERS: currentFollower + 1});
      }
    });
  }

  Future<void> unfollowUser(
      {required String myUserKey, required String otherUserKey}) async {
    final DocumentReference myUserRef =
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(myUserKey);
    final DocumentSnapshot mySnapshot = await myUserRef.get();
    final DocumentReference otherUserRef = FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .doc(otherUserKey);
    final DocumentSnapshot otherSnapshot = await otherUserRef.get();

    FirebaseFirestore.instance.runTransaction((tx) async {
      if (mySnapshot.exists && otherSnapshot.exists) {
        tx.update(myUserRef, {
          KEY_FOLLOWINGS: FieldValue.arrayRemove([otherUserKey])
        });
        int currentFollower = otherSnapshot.data()![KEY_FOLLOWERS];
        tx.update(otherUserRef, {KEY_FOLLOWERS: currentFollower - 1});
      }
    });
  }
}

UserNetworkRepository userNetworkRepository = UserNetworkRepository();
