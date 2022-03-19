class Post {
  String body;
  String author;
  int likes = 0;
  int dislikes = 0;
  bool userLiked = false;
  bool userDisLiked = false;

  Post(this.body, this.author);

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
