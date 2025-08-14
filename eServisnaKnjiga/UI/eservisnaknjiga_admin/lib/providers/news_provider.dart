import 'package:eservisnaknjiga_admin/models/news.dart';
import 'package:eservisnaknjiga_admin/providers/base_provider.dart';

class NewsProvider extends BaseProvider<News> {
  NewsProvider() : super("Novosti");

  @override
  News fromJson(data) {
    // TODO: implement fromJson
    return News.fromJson(data);
  }
}
