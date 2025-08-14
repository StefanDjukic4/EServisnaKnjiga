import 'package:eservisnaknjiga_mobile/models/news.dart';
import 'package:eservisnaknjiga_mobile/models/search_result.dart';
import 'package:eservisnaknjiga_mobile/providers/news_provider.dart';
import 'package:eservisnaknjiga_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  late NewsProvider _newsProvider;
  SearchResult<News>? result;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _newsProvider = context.read<NewsProvider>();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var data = await _newsProvider.get();
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Pocetna stranica",
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              result == null
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(child: _buildNewsListView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsListView() {
    var sortedNewsList = result?.result ?? [];
    sortedNewsList.sort((a, b) {
      return b.id!.compareTo(a.id!);
    });

    return ListView.builder(
      itemCount: sortedNewsList.length,
      itemBuilder: (context, index) {
        var newsItem = sortedNewsList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  newsItem.naslov ?? "Naziv nije dostupan",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  newsItem.tekst ?? "Sadrzaj nije dostupan",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
