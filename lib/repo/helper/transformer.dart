import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dongstagram/models/firestore/comment_model.dart';
import 'package:dongstagram/models/firestore/post_model.dart';
import 'package:dongstagram/models/firestore/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Transformers {
  final toUser = StreamTransformer<DocumentSnapshot, UserModel>.fromHandlers(
    handleData: (snapshot, sink) async {
      sink.add(UserModel.fromSnapshot(snapshot));
    }
  );

  final toUsersExceptMe = StreamTransformer<QuerySnapshot, List<UserModel>>.fromHandlers(
      handleData: (snapshot, sink) async {

        List<UserModel> users = [];
        User? _firebaseUser = FirebaseAuth.instance.currentUser;
        snapshot.docs.forEach((documentSnapshots) {
          if(_firebaseUser!.uid != documentSnapshots.id)              // 내 아이디를 제외하고
            users.add(UserModel.fromSnapshot(documentSnapshots));
        });

        sink.add(users);
      }
  );

  final toPosts = StreamTransformer<QuerySnapshot, List<PostModel>>.fromHandlers(
      handleData: (snapshot, sink) async {

        List<PostModel> posts = [];

        snapshot.docs.forEach((documentSnapshots) {
          posts.add(PostModel.fromSnapshot(documentSnapshots));
        });

        sink.add(posts);
      }
  );

  final latestToTop = StreamTransformer<List<PostModel>, List<PostModel>>.fromHandlers(
      handleData: (posts, sink) async {

        posts.sort((a, b)=>b.postTime.compareTo(a.postTime));
        sink.add(posts);
      }
  );

  final combineListOfPosts = StreamTransformer<List<List<PostModel>>, List<PostModel>>.fromHandlers(        // List<List<PostModel>>을 List<PostModel>로 바꿔준다.
      handleData: (listOfPosts, sink) async {

        List<PostModel> posts = [];

        for(final postList in listOfPosts){
          posts.addAll(postList);         // postList의 모든 elements들을 posts에 넣어주라
        }

        sink.add(posts);
      }
  );

  final toComments = StreamTransformer<QuerySnapshot, List<CommentModel>>.fromHandlers(
      handleData: (snapshot, sink) async {

        List<CommentModel> comments = [];

        snapshot.docs.forEach((documentSnapshots) {
          comments.add(CommentModel.fromSnapshot(documentSnapshots));
        });

        sink.add(comments);
      }
  );

}
