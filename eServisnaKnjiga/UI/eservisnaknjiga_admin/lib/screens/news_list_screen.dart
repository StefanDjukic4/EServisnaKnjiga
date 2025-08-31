import 'dart:convert';
import 'dart:io';

import 'package:eservisnaknjiga_admin/models/news.dart';
import 'package:eservisnaknjiga_admin/models/search_result.dart';
import 'package:eservisnaknjiga_admin/providers/news_provider.dart';
import 'package:eservisnaknjiga_admin/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
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

  File? _image;
  String? _base64Image;

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
            dataRowMaxHeight: 150,
            columns: const [
              DataColumn(
                  label: Text('Naslov',
                      style: TextStyle(fontStyle: FontStyle.italic))),
              DataColumn(
                  label: Text('Tekst',
                      style: TextStyle(fontStyle: FontStyle.italic))),
              DataColumn(
                  label: Text('Datum objave',
                      style: TextStyle(fontStyle: FontStyle.italic))),
              DataColumn(
                  label: Text('Slika',
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
                      DataCell(Text(e.datumObjave != null
                          ? "${e.datumObjave!.day}/${e.datumObjave!.month}/${e.datumObjave!.year}"
                          : "")),
                      DataCell(
                        SizedBox(
                          width: 120,
                          child: (e.slika != null && e.slika!.isNotEmpty)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    base64Decode(e.slika!),
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  ),
                                )
                              : const Text("Nema slike"),
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
                            bool? confirm = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Potvrda brisanja"),
                                  content: const Text(
                                      "Da li ste sigurni da želite obrisati vijest?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("Ne"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("Da"),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm == true) {
                              await _newsProvider.delete(e.id!);

                              var data = await _newsProvider.get(filter: {
                                'naslov': _naslovController.text,
                                'tekst': _textController.text
                              });
                              setState(() {
                                result = data;
                              });
                            }
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
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
              maxHeight: 700,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: FormBuilder(
                key: _formKey,
                initialValue: _initialValue,
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
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
                    FormBuilderField<String>(
                      name: 'slika',
                      builder: (field) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputDecorator(
                              decoration: InputDecoration(
                                label: const Text('Slika'),
                                errorText: field.errorText,
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.photo),
                                title: const Text("Odaberite sliku"),
                                trailing: const Icon(Icons.file_upload),
                                onTap: () async {
                                  await getImage();
                                  field.didChange(_base64Image); // OBAVEZNO
                                  setState(
                                      () {}); // odmah rebuild da se prikaže slika
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (_base64Image != null &&
                                _base64Image!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  height: 200,
                                  width: 400,
                                  child: Image.memory(
                                    base64Decode(_base64Image!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            else
                              const Text("Nema slike"),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          try {
                            var formData = Map<String, dynamic>.from(
                                _formKey.currentState!.value);

                            // Ako je dodavanje nove vijesti, postavi datumObjave
                            if (news == null) {
                              formData['datumObjave'] =
                                  DateTime.now().toIso8601String();
                            }
                            if (news == null) {
                              await _newsProvider.insert(formData);
                            } else {
                              await _newsProvider.update(news!.id!, formData);
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
          ),
        );
      },
    );
  }

  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
      setState(() {}); // odmah prikaži odabranu sliku
    }
  }

  Future<void> _updateText({news}) async => setState(() {
        _initialValue = {
          if (news != null) 'naslov': news.naslov ?? '' else 'naslov': '',
          if (news != null) 'tekst': news.tekst ?? '' else 'tekst': '',
        };
        if (news != null && news.slika != null && news.slika!.isNotEmpty) {
          _base64Image = news.slika;
        } else {
          _base64Image = null;
        }
        _openPopup(context, news);
      });
}
