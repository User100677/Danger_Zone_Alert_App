class Post {
  String id;
  int likes;
  int dislikes;
  String email;
  String content;
  bool userLiked = false;
  bool userDisLiked = false;

  Post(this.id, this.content, this.email, {this.likes = 0, this.dislikes = 0});

  void likePost() {
    userLiked = !userLiked;
    if (userLiked) {
      likes += 1;
    } else {
      likes -= 1;
    }
  }

  void dislikePost() {
    userDisLiked = !userDisLiked;
    if (userDisLiked) {
      dislikes += 1;
    } else {
      dislikes -= 1;
    }
  }

  void clash1() {
    if (likes == 1) {
      if (userDisLiked) {
        userLiked = !userLiked;
        likes -= 1;
        return;
      } else {
        return;
      }
    }
  }

  void clash2() {
    if (dislikes == 1) {
      if (userLiked) {
        userDisLiked = !userDisLiked;
        dislikes -= 1;
        return;
      } else {
        return;
      }
    }
  }
}
