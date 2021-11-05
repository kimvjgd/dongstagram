import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dongstagram/constant/firestore_keys.dart';
import 'package:dongstagram/models/firestore/post_model.dart';
import 'package:dongstagram/repo/helper/transformer.dart';
import 'package:rxdart/rxdart.dart';

class PostNetworkRepository with Transformers {
  Future<Map<String, dynamic>?> createNewPost(String postKey,
      Map<String, dynamic> postData) async {
    final DocumentReference postRef =
    FirebaseFirestore.instance.collection(COLLECTION_POSTS).doc(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();
    final DocumentReference userRef = FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .doc(postData[KEY_USERKEY]);

    FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      // 중간에 뭐 하나 잘못되면 이전상태로 돌아가게 한다.  안전하다.
      if (!postSnapshot.exists) {
        // postSnapshot이 존재하지 않으면
        tx.set(postRef, postData); // 여기는 POSTDATA 업로드하는 거고
        tx.update(userRef, {
          KEY_MYPOSTS: FieldValue.arrayUnion([postKey])
        }); // map에 추가
      }
    });
  }

  Future<void> updatePostImageUrl(
      {required String postImg, required String postKey}) async {
    final DocumentReference postRef =
    FirebaseFirestore.instance.collection(COLLECTION_POSTS).doc(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();

    if (postSnapshot.exists) {
      print('update전');
      await postRef.update({KEY_POSTIMG: postImg});
      print('update후');
    }
  }

  Stream<void> getPostsFromSpecificUser(String userKey) {
    return FirebaseFirestore.instance
        .collection(COLLECTION_POSTS)
        .where(KEY_USERKEY, isEqualTo: userKey)
        .snapshots()
        .transform(toPosts);
  }

  Stream<List<PostModel>> fetchPostsFromAllFollowers(List<dynamic> followings) {
    final CollectionReference collectionReference = FirebaseFirestore.instance.collection(COLLECTION_POSTS);
    List<Stream<List<PostModel>>> streams = [];

    for(final following in followings) {
      streams.add(collectionReference.where(KEY_USERKEY, isEqualTo: following).snapshots().transform(toPosts));
    }
    // 이렇게 까지오면 List<Stream<List<PostModel>>>로 오는데 다시 List<PostModel>로 바꿔줘야한다(combinListOfPosts이용)
    return CombineLatestStream.list<List<PostModel>>(streams).transform(combineListOfPosts).transform(latestToTop);
  }

  Future<void> toggleLike(String postKey, String userKey) async{
    final DocumentReference postRef = FirebaseFirestore.instance.collection(COLLECTION_POSTS).doc(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();

    if(postSnapshot.exists){
      if(postSnapshot.data()![KEY_NUMOFLIKES].contains(userKey)){
        postRef.update({KEY_NUMOFLIKES: FieldValue.arrayRemove([userKey])});
      } else {
        postRef.update({KEY_NUMOFLIKES: FieldValue.arrayUnion([userKey])});
      }
    }

  }
}

PostNetworkRepository postNetworkRepository = PostNetworkRepository();
