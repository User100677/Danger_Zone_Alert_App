import 'package:danger_zone_alert/comment/post.dart';
import 'package:flutter/material.dart';

class PostList extends StatefulWidget {
  final List<Post> listItems;

  const PostList(this.listItems, {Key? key}) : super(key: key);

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
    return ListView.builder(
      itemCount: widget.listItems.length,
      itemBuilder: (context, index) {
        var post = widget.listItems[index];
        return Card(
          child: Row(children: <Widget>[
            Expanded(
                child: ListTile(
              title: Text(post.content),
              subtitle: Text(post.email),
            )),
            Row(
              children: <Widget>[
                Container(
                    child: Text(post.likes.toString(),
                        style: const TextStyle(fontSize: 20)),
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
                IconButton(
                    icon: const Icon(Icons.thumb_up),
                    onPressed: () => [
                          like(post.likePost),
                          like(post.clash2),
                        ],
                    color: post.userLiked ? Colors.green : Colors.black),
                Container(
                    child: Text(post.dislikes.toString(),
                        style: const TextStyle(fontSize: 20)),
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
                IconButton(
                    icon: const Icon(Icons.thumb_down),
                    onPressed: () =>
                        [dislike(post.dislikePost), dislike(post.clash1)],
                    color: post.userDisLiked ? Colors.red : Colors.black),
              ],
            )
          ]),
        );
      },
    );
  }
}
