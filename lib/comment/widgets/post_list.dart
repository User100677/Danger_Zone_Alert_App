import 'package:danger_zone_alert/comment/model/post.dart';
import 'package:danger_zone_alert/models/area.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:danger_zone_alert/services/database.dart';
import 'package:flutter/material.dart';

class PostList extends StatefulWidget {
  final UserModel user;
  final Area area;

  const PostList(this.user, this.area, {Key? key}) : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  List<Post> posts = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Comment>>(
        stream: DatabaseService(uid: widget.user.uid)
            .getAreaComments(widget.area.latLng),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            posts.clear();

            for (Comment comment in snapshot.requireData) {
              posts.add(Post(widget.user, widget.area.latLng, comment));
            }
          }
          return StreamBuilder<List<CommentedArea>>(
              stream: DatabaseService(uid: widget.user.uid)
                  .getUserCommentsData(widget.area.latLng),
              builder: (context, snapshot) {
                if (snapshot.hasData && posts.isNotEmpty) {
                  for (CommentedArea commentedArea in snapshot.requireData) {
                    for (int i = 0; i < posts.length; i++) {
                      if (commentedArea.id == posts[i].id) {
                        posts[i].userLiked = commentedArea.isLiked;
                        posts[i].userDisLiked = commentedArea.isDisliked;
                      }
                    }
                  }
                }
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    var post = posts[index];
                    return Card(
                      child: Row(children: <Widget>[
                        Expanded(
                            child: ListTile(
                                title: Text(post.content),
                                subtitle: Text(post.email))),
                        Row(
                          children: <Widget>[
                            Container(
                                child: Text(post.likes.toString(),
                                    style: const TextStyle(fontSize: 20)),
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 10, 0)),
                            IconButton(
                                icon: const Icon(Icons.thumb_up),
                                onPressed: () => post.likePost(),
                                color: post.userLiked
                                    ? Colors.green
                                    : Colors.black),
                            Container(
                                child: Text(post.dislikes.toString(),
                                    style: const TextStyle(fontSize: 20)),
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 10, 0)),
                            IconButton(
                                icon: const Icon(Icons.thumb_down),
                                onPressed: () => post.dislikePost(),
                                color: post.userDisLiked
                                    ? Colors.red
                                    : Colors.black),
                          ],
                        )
                      ]),
                    );
                  },
                );
              });
        });
  }
}
