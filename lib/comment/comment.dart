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

  const CommentScreen({
    Key? key,
    required this.user,
    required this.area,
  }) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  handleCommentPressed(String text) async {
    await DatabaseService(uid: widget.user.uid)
        .postAreaCommentData(widget.area.latLng, text, widget.user.email);
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
                ))),
        body: Column(children: <Widget>[
          Expanded(child: PostList(widget.user, widget.area)),
          TextInputWidget(handleCommentPressed),
        ]));
  }
}
