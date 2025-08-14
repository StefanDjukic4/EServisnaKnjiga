import 'package:eservisnaknjiga_mobile/models/news.dart';
import 'package:eservisnaknjiga_mobile/providers/base_provider.dart';

class NewsProvider extends BaseProvider<News> {
  NewsProvider() : super("Novosti/Klijent");

  @override
  News fromJson(data) {
    // TODO: implement fromJson
    return News.fromJson(data);
  }
}
