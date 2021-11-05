import 'package:dongstagram/constant/common_size.dart';
import 'package:dongstagram/models/firestore/comment_model.dart';
import 'package:dongstagram/models/firestore/user_model.dart';
import 'package:dongstagram/models/user_model_state.dart';
import 'package:dongstagram/repo/comment_network_repository.dart';
import 'package:dongstagram/widgets/comment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {

final String postKey;

  const CommentsScreen({Key? key, required this.postKey}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController _textEditingController = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            Expanded(
              child: StreamProvider<List<CommentModel>>.value(
                initialData: [],
                value: commentNetworkRepository.fetchAllComments(widget.postKey),
                child: Consumer<List<CommentModel>>(
                  builder: (BuildContext context, List<CommentModel> comments, Widget? child) {
                    return ListView.separated(
                      reverse: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(common_xxs_gap),
                            child: Comment(text: comments[index].comment, username: comments[index].username, dateTime: comments[index].commentTime, showImage: true,),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: common_xs_gap,);
                        },
                        itemCount: comments.length);
                  },
                ),
              ),
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[300],),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: common_gap),
                    child: TextFormField(
                      controller: _textEditingController,
                      cursorColor: Colors.black54,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: InputBorder.none,
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Input something';
                        } else {
                          return null;              // validate통과
                        }
                      },
                    ),
                  ),
                ),
                FlatButton(
                    onPressed: () async{
                      if (_formkey.currentState!.validate()) {
                        print('여기까지는 된다.0');
                        UserModel usermodel = Provider.of<UserModelState>(context, listen: false).userModel;
                        print('여기까지는 된다.1');
                        Map<String ,dynamic> newComment = CommentModel.getMapForNewComment(usermodel.userKey, usermodel.username, _textEditingController.text);
                        print('여기까지는 된다.2');
                        await commentNetworkRepository.createNewComment(widget.postKey, newComment);
                        print('여기까지는 된다.3');
                        _textEditingController.clear();
                      }
                    },
                    child: Text('Post')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
