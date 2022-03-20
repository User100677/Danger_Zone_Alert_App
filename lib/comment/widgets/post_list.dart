import 'package:danger_zone_alert/comment/model/post.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:danger_zone_alert/services/database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PostList extends StatefulWidget {
  final List<Post> posts;
  final UserModel user;
  final LatLng latLng;

  const PostList(this.posts, this.user, this.latLng, {Key? key})
      : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  void like(Function callBack) {
    setState(() {
      callBack();
    });
  }

  void dislike(Function callBack) {
    setState(() {
      callBack();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CommentedArea>>(
        stream: DatabaseService(uid: widget.user.uid)
            .getUserCommentsData(widget.latLng),
        builder: (context, snapshot) {
          snapshot.hasData ? print('data exist') : print("data doesn't exist!");
          if (snapshot.hasData) {
            for (CommentedArea commentedArea in snapshot.requireData) {
              for (int i = 0; i < widget.posts.length; i++) {
                if (commentedArea.id == widget.posts[i].id) {
                  widget.posts[i].userLiked = commentedArea.isLiked;
                  widget.posts[i].userDisLiked = commentedArea.isDisliked;
                }
              }
            }
          }

          return ListView.builder(
            itemCount: widget.posts.length,
            itemBuilder: (context, index) {
              var post = widget.posts[index];
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
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
                      IconButton(
                          icon: const Icon(Icons.thumb_up),
                          onPressed: () {
                            // [like(post.likePost), like(post.clash2)];

                            DatabaseService(uid: widget.user.uid)
                                .updateUserLikesData(widget.latLng, post.id,
                                    post.userLiked, post.userDisLiked);

                            DatabaseService(uid: widget.user.uid)
                                .updateAreaLikesData(widget.latLng, post.id,
                                    post.userLiked, post.userDisLiked);
                          },
                          color: post.userLiked ? Colors.green : Colors.black),
                      Container(
                          child: Text(post.dislikes.toString(),
                              style: const TextStyle(fontSize: 20)),
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
                      IconButton(
                          icon: const Icon(Icons.thumb_down),
                          onPressed: () {
                            // [dislike(post.dislikePost), dislike(post.clash1)];
                            // dislike(post.dislikePost);
                            // dislike(post.clash1);

                            DatabaseService(uid: widget.user.uid)
                                .updateUserDislikesData(widget.latLng, post.id,
                                    post.userLiked, post.userDisLiked);

                            DatabaseService(uid: widget.user.uid)
                                .updateAreaDislikesData(widget.latLng, post.id,
                                    post.userLiked, post.userDisLiked);
                          },
                          color: post.userDisLiked ? Colors.red : Colors.black),
                    ],
                  )
                ]),
              );
            },
          );
        });
  }
}
