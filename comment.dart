import 'package:flutter/material.dart';

void main() 
{
  runApp(const MyApp());
}

class Post
{
  String body;
  String author;
  int likes = 0;
  int dislikes = 0;
  bool userLiked = false;
  bool userdisLiked = false;

  Post(this.body, this.author);

  void likePost()
  {
    this.userLiked = !this.userLiked;
    if(this.userLiked)
    {
      this.likes += 1;
    } 
    else
    {
      this.likes -= 1;
    }
  }
  
  void dislikePost()
  {
    this.userdisLiked = !this.userdisLiked;
    if(this.userdisLiked)
    {
      this.dislikes += 1;
    } else
    {
      this.dislikes -= 1;
    }
  }

  void clash1()
  {
    if(this.likes == 1)
    {
      if(this.userdisLiked)
      {
        this.userLiked = !this.userLiked;
        this.likes -= 1;
        return;
      }
      else
      {
        return;
      }
    }
  }

  void clash2()
  {
    if(this.dislikes == 1)
    {
      if(this.userLiked)
      {
        this.userdisLiked = !this.userdisLiked;
        this.dislikes -= 1;
        return;
      }
      else
      {
        return;
      }
    }
  }
}




class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SEGP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:MyHomePage() ,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  List<Post> posts = [];

  void newPost(String text){
    this.setState((){
      posts.add(new Post(text, "Darolyn"));
    });
    
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comments')),
      body: Column(children: <Widget> [
        Expanded(child:PostList(this.posts)),
        TextInputWidget(this.newPost),
      ]));
  }
}


class TextInputWidget extends StatefulWidget {
  final Function(String)callback; 

  TextInputWidget(this.callback);

  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  final controller = TextEditingController();

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

 void click(){
    FocusScope.of(context).unfocus();
    widget.callback(controller.text);
   controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: this.controller,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.message), 
          labelText: "Type a message:",
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            splashColor: Colors.blueAccent,
            tooltip:"Post message", 
            onPressed: this.click,
          )));
  }
}

class PostList extends StatefulWidget {

  final List<Post> listItems;

  PostList(this.listItems);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList>{
  void like(Function callBack){
    this.setState(() {
      callBack();
    });
  }
  
  void dislike(Function callBack){
    this.setState(() {
      callBack();
    });
  }



  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.widget.listItems.length,
      itemBuilder: (context, index){
        var post = this.widget.listItems[index];
        return Card(
          child: Row(children: <Widget>[
        Expanded(child:ListTile(
          title: Text(post.body),
          subtitle:Text(post.author),
        )),
        Row(children: <Widget>[

          Container(child:Text(post.likes.toString(), 
          style: TextStyle(fontSize: 20)),
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),),
          IconButton(
            icon: Icon(Icons.thumb_up),
            onPressed: () => [ this.like(post.likePost), this.like(post.clash2),],
            color: post.userLiked ? Colors. green : Colors.black),

          Container(child:Text(post.dislikes.toString(), 
          style: TextStyle(fontSize: 20)),
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),),
          IconButton(
            icon: Icon(Icons.thumb_down),
            onPressed: () => [this.dislike(post.dislikePost), this.dislike(post.clash1), ],
            color: post.userdisLiked ? Colors. green : Colors.black),
          ],
        )
        
      ]));
      },
    );
  }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }