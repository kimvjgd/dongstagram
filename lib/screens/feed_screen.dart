import 'package:dongstagram/models/firestore/post_model.dart';
import 'package:dongstagram/repo/post_network_repository.dart';
import 'package:dongstagram/widgets/my_progress_indicator.dart';
import 'package:dongstagram/widgets/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatelessWidget {

  final List<dynamic> followings;

  const FeedScreen({Key? key, required this.followings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PostModel>>.value(
      initialData: [],
      value: postNetworkRepository.fetchPostsFromAllFollowers(followings),
      child: Consumer<List<PostModel>>(
        builder: (BuildContext context, List<PostModel> posts, Widget? child){
          if(posts.isEmpty) {
            return MyProgressIndicator(containerSize: 100);
          } else {
            return Scaffold(
              appBar: CupertinoNavigationBar(
                leading: IconButton(
                  onPressed: null,
                  icon: Icon(
                    CupertinoIcons.photo_camera_solid,
                    color: Colors.black87,
                  ),
                ),
                middle: Text('instagram',
                    style: TextStyle(
                        fontFamily: 'DongStyle', color: Colors.black)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {

                      },
                      icon: ImageIcon(
                        AssetImage('assets/images/actionbar_camera.png'),
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      onPressed: () {

                      },
                      icon: ImageIcon(
                        AssetImage('assets/images/direct_message.png'),
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              body: ListView.builder(
                itemBuilder: (context, index)=>feedListBuilder(context, posts[index]),
                itemCount: posts.length,
              ),
            );
          }
        },
      ),
    );
  }

  Widget feedListBuilder(BuildContext context, PostModel postModel) {
    return Post(postModel: postModel);
  }
}


