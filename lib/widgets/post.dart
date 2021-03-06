import 'package:cached_network_image/cached_network_image.dart';
import 'package:dongstagram/constant/common_size.dart';
import 'package:dongstagram/constant/screen_size.dart';
import 'package:dongstagram/models/firestore/post_model.dart';
import 'package:dongstagram/models/user_model_state.dart';
import 'package:dongstagram/repo/post_network_repository.dart';
import 'package:dongstagram/screens/comments_screen.dart';
import 'package:dongstagram/widgets/comment.dart';
import 'package:dongstagram/widgets/my_progress_indicator.dart';
import 'package:dongstagram/widgets/rounded_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Post extends StatelessWidget {
  final PostModel postModel;

  const Post({Key? key, required this.postModel}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _postHeader(),
        _postImage(),
        _postActions(context),
        _postLikes(),
        _postCaption(),
        _lastComment(),
        _moreComments(context),
      ],
    );
  }

  Widget _postCaption() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_xxs_gap),
      child: Comment(
        showImage: false,
        text: postModel.caption,
        username: postModel.username,
      ),
    );
  }

  Widget _lastComment() {
    return Padding(
      padding: const EdgeInsets.only(
          left: common_gap, right: common_gap, top: common_xxs_gap),
      child: Comment(
        showImage: false,
        text: postModel.lastCommentor,
        username: postModel.lastComment,
      ),
    );
  }


  Padding _postLikes() {
    return Padding(
      padding: const EdgeInsets.only(left: common_gap),
      child: Text(
        '${postModel.numOfLikes.length} likes',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Row _postActions(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: null,
          icon: ImageIcon(AssetImage('assets/images/bookmark.png')),
          color: Colors.black87,
        ),
        IconButton(
          onPressed: (){_goToComments(context);},
          icon: ImageIcon(AssetImage('assets/images/comment.png')),
          color: Colors.black87,
        ),
        IconButton(
          onPressed: null,
          icon: ImageIcon(AssetImage('assets/images/direct_message.png')),
          color: Colors.black87,
        ),
        Spacer(),
        Consumer<UserModelState>(
          builder: (BuildContext context, UserModelState userModelState, Widget? child){
            return IconButton(
              onPressed: () {
                postNetworkRepository.toggleLike(postModel.postKey, userModelState.userModel.userKey);
              },
              icon: ImageIcon(AssetImage(postModel.numOfLikes.contains(userModelState.userModel.userKey)?'assets/images/heart_selected.png':'assets/images/heart.png'), color: Colors.redAccent,),
              color: Colors.black87,
            );
          },
        ),
      ],
    );
  }

  Widget _postImage() {
    Widget progress = MyProgressIndicator(containerSize: size!.width);
    return CachedNetworkImage(
      imageUrl: postModel.postImg,
      placeholder: (BuildContext context, String url) {
        return progress;
      },
      imageBuilder: (BuildContext context, ImageProvider imageProvider) {
        return AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
                image:
                DecorationImage(image: imageProvider, fit: BoxFit.cover)),
          ),
        );
      },
    );
  }

  Widget _postHeader() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(common_xxs_gap),
          child: RoundedAvatar(),
        ),
        Expanded(child: Text(postModel.username)),
        IconButton(
          icon: Icon(
            Icons.more_horiz,
            color: Colors.black87,
          ),
          onPressed: null,
        )
      ],
    );
  }

  Widget _moreComments(BuildContext context) {
    return Visibility(
      visible: (postModel.numOfComments != null &&
          postModel.numOfComments >= 2),
      child: GestureDetector(
        onTap: (){_goToComments(context);},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: common_gap),
          child: Text(
              '${postModel.numOfComments - 1} more comments...'
          ),
        ),
      ),
    );
  }

  _goToComments(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return CommentsScreen(postKey: postModel.postKey);
    }));
  }
}
