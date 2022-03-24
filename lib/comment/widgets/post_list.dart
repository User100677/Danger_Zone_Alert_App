import 'package:danger_zone_alert/comment/model/post.dart';
import 'package:danger_zone_alert/comment/utils/convert_time.dart';
import 'package:danger_zone_alert/models/area.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:danger_zone_alert/services/database.dart';
import 'package:danger_zone_alert/widget_view/widget_view.dart';
import 'package:flutter/material.dart';

class PostList extends StatefulWidget {
  final Area area;
  final UserModel user;
  final Function sortView;

  const PostList(
      {required this.area,
      required this.user,
      required this.sortView,
      Key? key})
      : super(key: key);

  @override
  _PostListController createState() => _PostListController();
}

class _PostListController extends State<PostList> {
  @override
  Widget build(BuildContext context) => _PostListView(this);
}

class _PostListView extends WidgetView<PostList, _PostListController> {
  _PostListView(_PostListController state) : super(state);

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

                List<Post> sortedPosts = widget.sortView(posts);

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    Post post = sortedPosts[index];
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: ListTile(
                                title: Text(
                                  post.content,
                                  style: const TextStyle(
                                      fontSize: 21.0, color: Color(0xff1a1a1b)),
                                ),
                              )),
                              Row(
                                children: <Widget>[
                                  Container(
                                      child: Text(post.likes.toString(),
                                          style: const TextStyle(fontSize: 18)),
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 8, 0)),
                                  IconButton(
                                      icon: const Icon(Icons.thumb_up),
                                      onPressed: () => post.likePost(),
                                      color: post.userLiked
                                          ? Colors.green
                                          : Colors.black),
                                  Container(
                                      child: Text(post.dislikes.toString(),
                                          style: const TextStyle(fontSize: 18)),
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 8, 0)),
                                  IconButton(
                                      icon: const Icon(Icons.thumb_down),
                                      onPressed: () => post.dislikePost(),
                                      color: post.userDisLiked
                                          ? Colors.red
                                          : Colors.black),
                                ],
                              ),
                            ],
                          ),
                          Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    post.email,
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Color(0xff7c7c7c),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    convertTime(post.dateTime),
                                    style: const TextStyle(
                                        fontSize: 13.0,
                                        color: Color(0xff7c7c7c)),
                                  ),
                                ],
                              ),
                              padding:
                                  const EdgeInsets.fromLTRB(15, 0, 15, 15)),
                        ],
                      ),
                    );
                  },
                );
              });
        });
  }
}
