import 'package:danger_zone_alert/comment/post.dart';
import 'package:danger_zone_alert/comment/widgets/post_list.dart';
import 'package:danger_zone_alert/comment/widgets/text_input.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  static String id = "comment_screen";

  const CommentScreen({Key? key}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<Post> posts = [];

  void newPost(String text) {
    setState(() {
      posts.add(Post(text, "Darolyn"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Comments'),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_sharp,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(children: <Widget>[
          Expanded(child: PostList(posts)),
          TextInputWidget(newPost),
        ]));
  }
}
