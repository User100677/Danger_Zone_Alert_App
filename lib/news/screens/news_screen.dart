import 'package:danger_zone_alert/news/screens/article_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/model/error.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';

import '../widgets/custom_dialog_route.dart';

// This class is used to display latest list of news using the News API
class NewsScreen extends StatelessWidget {
  final NewsAPI _newsAPI = NewsAPI("434b5638ed034f98a296145d4e2a7462");

  NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: const Color(0xffDAE0E6),
        appBar: _buildAppBar(context),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar(context) {
    return AppBar(
      centerTitle: true,
      title: const Text("News",
          style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.w800)),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      children: [
        _buildEverythingTabView(),
      ],
    );
  }

  Widget _buildEverythingTabView() {
    return FutureBuilder<List<Article>>(
        future:
            _newsAPI.getEverything(query: "crime", domains: "thestar.com.my"),
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? snapshot.hasData
                  ? _buildArticleListView(snapshot.data!)
                  : _buildError(snapshot.error as ApiError)
              : _buildProgress();
        });
  }

  Widget _buildArticleListView(List<Article> articles) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        Article article = articles[index];
        return InkWell(
          // Display the details of the article in a dialog box form after users tap on one of the news
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(HeroDialogRoute(
                  builder: (context) =>
                      Center(child: ArticlePage(article: article))));
            },
            child: Card(
              child: ListTile(
                title: Text(article.title!, maxLines: 2),
                subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: Text(article.description ?? "", maxLines: 2)),
                minVerticalPadding: 12.0,
                trailing: article.urlToImage == null
                    ? null
                    : Image.network(article.urlToImage!),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgress() {
    return const Center(child: CircularProgressIndicator());
  }

  // Show error if the News API can't get any news
  Widget _buildError(ApiError error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error.code ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(error.message!, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
