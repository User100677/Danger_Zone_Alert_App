import 'package:danger_zone_alert/comment/post.dart';
import 'package:danger_zone_alert/comment/widgets/post_list.dart';
import 'package:danger_zone_alert/comment/widgets/text_input.dart';
import 'package:danger_zone_alert/models/area.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:danger_zone_alert/services/database.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  static String id = "comment_screen";
  final UserModel user;
  final Area area;
  final int areaIndex;

  const CommentScreen(
      {Key? key,
      required this.user,
      required this.area,
      required this.areaIndex})
      : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<Post> posts = [];

  handleCommentPressed(String text) async {
    await DatabaseService(uid: widget.user.uid)
        .postAreasCommentData(widget.area.latLng, text, widget.user.email);

    print('Comment completed!');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Comment>>(
        stream: DatabaseService(uid: widget.user.uid)
            .getAreaComments(widget.area.latLng),
        builder: (context, snapshot) {
          posts.clear();
          if (snapshot.hasData) {
            List<Comment> comments;
            areaList[widget.areaIndex].comment.clear();
            areaList[widget.areaIndex].comment.addAll(snapshot.requireData);
            comments = areaList[widget.areaIndex].comment;

            for (Comment comment in comments) {
              posts.add(Post(comment.content, comment.email,
                  likes: comment.like, dislikes: comment.dislike));
            }
          }

          // widget view
          return Scaffold(
              appBar: AppBar(
                  title: const Text('Comments'),
                  leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_sharp,
                        size: 20,
                        color: Colors.white,
                      ))),
              body: Column(children: <Widget>[
                Expanded(child: PostList(posts)),
                TextInputWidget(handleCommentPressed),
              ]));
        });
  }
}
