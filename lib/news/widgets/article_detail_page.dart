import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_rect_tween.dart';

const String _heroAddTodo = 'add-todo-hero';

class ArticlePage extends StatelessWidget {
  final Article article;
  const ArticlePage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Hero(
          tag: _heroAddTodo,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Material(
            color: Colors.white,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  article.urlToImage != null
                      ? Container(
                          height: 150.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(article.urlToImage ?? ""),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        )
                      : Container(
                          height: 150.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: NetworkImage(
                                    'https://source.unsplash.com/weekly?coding'),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                  const SizedBox(height: 8.0),
                  Text(
                   DateFormat("yyyy-MM-dd").format(DateTime.parse(article.publishedAt ?? "")),
                    style: const TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      decorationThickness: 1,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 0),
                  Text(article.title ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25.0)),
                  const SizedBox(height: 5.0),
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          children: [
                        TextSpan(
                            text: article.description!
                                .replaceAll("Read full story", ""),
                            style: const TextStyle()),
                        TextSpan(
                            text: "Read Full Story",
                            style: const TextStyle(
                              color: Colors.blueAccent,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch(article.url ?? "");
                              })
                      ])),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
