import 'package:eservisnaknjiga_admin/models/news.dart';
import 'package:eservisnaknjiga_admin/models/search_result.dart';
import 'package:eservisnaknjiga_admin/providers/news_provider.dart';
import 'package:eservisnaknjiga_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  News? news;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late NewsProvider _newsProvider;
  late TextEditingController _naslovController;
  late TextEditingController _textController;
  SearchResult<News>? result;

  @override
  void initState() {
    super.initState();
    _naslovController = TextEditingController();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _naslovController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _newsProvider = context.read<NewsProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Novosti",
      child: Column(
        children: [
          _buildSearch(),
          _buildDataListView(),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(labelText: "Naslov"),
              controller: _naslovController,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(labelText: "Tekst"),
              controller: _textController,
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () async {
              var data = await _newsProvider.get(filter: {
                'naslov': _naslovController.text,
                'tekst': _textController.text
              });
              setState(() {
                result = data;
              });
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Pretraga'),
                SizedBox(width: 8),
                Icon(Icons.search_outlined),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              _updateText();
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Dodaj novu vijest'),
                SizedBox(width: 8),
                Icon(Icons.add),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataListView() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            dataRowMaxHeight: 120,
            columns: const [
              DataColumn(
                  label: Text('Naslov',
                      style: TextStyle(fontStyle: FontStyle.italic))),
              DataColumn(
                  label: Text('Tekst',
                      style: TextStyle(fontStyle: FontStyle.italic))),
              DataColumn(
                  label: Text('Izmjeni',
                      style: TextStyle(fontStyle: FontStyle.italic))),
              DataColumn(
                  label: Text('Obrisi',
                      style: TextStyle(fontStyle: FontStyle.italic))),
            ],
            rows: result?.result.map((e) {
                  return DataRow(
                    cells: [
                      DataCell(Text(e.naslov ?? "")),
                      DataCell(
                        SizedBox(
                          width: 300,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(e.tekst ?? ""),
                          ),
                        ),
                      ),
                      DataCell(
                        ElevatedButton(
                          child: const Row(
                            children: [
                              Text('Izmjeni '),
                              Icon(Icons.edit_outlined),
                            ],
                          ),
                          onPressed: () {
                            _updateText(news: e);
                          },
                        ),
                      ),
                      DataCell(
                        ElevatedButton(
                          child: const Row(
                            children: [
                              Text('Obrisi'),
                              Icon(Icons.delete_outlined),
                            ],
                          ),
                          onPressed: () async {
                            await _newsProvider.delete(e.id!);
                            var data = await _newsProvider.get(filter: {
                              'naslov': _naslovController.text,
                              'tekst': _textController.text
                            });
                            setState(() {
                              result = data;
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }).toList() ??
                [],
          ),
        ),
      ),
    );
  }

  void _openPopup(BuildContext context, News? news) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                right: -40.0,
                top: -40.0,
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close),
                  ),
                ),
              ),
              FormBuilder(
                key: _formKey,
                initialValue: _initialValue,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FormBuilderTextField(
                        name: 'naslov',
                        decoration: const InputDecoration(labelText: 'Naslov'),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Naslov je obavezan'),
                          FormBuilderValidators.minLength(3,
                              errorText: 'Naslov mora imati barem 3 znaka'),
                          FormBuilderValidators.maxLength(100,
                              errorText:
                                  'Naslov ne smije imati više od 100 znakova'),
                        ]),
                      ),
                      const Padding(padding: EdgeInsets.all(10.0)),
                      FormBuilderTextField(
                        name: 'tekst',
                        decoration: InputDecoration(
                          labelText: 'Tekst',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 25.0, horizontal: 12.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        style: const TextStyle(fontSize: 18.0),
                        minLines: 3,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Tekst je obavezan'),
                          FormBuilderValidators.minLength(10,
                              errorText: 'Tekst mora imati barem 10 znakova'),
                          FormBuilderValidators.maxLength(5000,
                              errorText:
                                  'Tekst ne smije imati više od 5000 znakova'),
                        ]),
                      ),
                      const Padding(padding: EdgeInsets.all(10.0)),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.saveAndValidate() ??
                              false) {
                            try {
                              if (news == null) {
                                await _newsProvider
                                    .insert(_formKey.currentState?.value);
                              } else {
                                await _newsProvider.update(
                                    news!.id!, _formKey.currentState?.value);
                              }
                              news = null;
                              Navigator.pop(context);
                            } on Exception catch (e) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text("Error"),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("OK"),
                                    )
                                  ],
                                ),
                              );
                            }
                          }
                        },
                        child: Text(news == null
                            ? "Dodaj novu vijest"
                            : "Izmjeni vijest"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateText({news}) async => setState(() {
        _initialValue = {
          if (news != null) 'naslov': news.naslov ?? '' else 'naslov': '',
          if (news != null) 'tekst': news.tekst ?? '' else 'tekst': '',
        };
        _openPopup(context, news);
      });
}
