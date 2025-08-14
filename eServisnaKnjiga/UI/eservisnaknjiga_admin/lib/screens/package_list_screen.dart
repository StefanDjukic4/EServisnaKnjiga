import 'dart:convert';
import 'dart:io';

import 'package:eservisnaknjiga_admin/models/package.dart';
import 'package:eservisnaknjiga_admin/models/search_result.dart';
import 'package:eservisnaknjiga_admin/providers/package_provider.dart';
import 'package:eservisnaknjiga_admin/utils/util.dart';
import 'package:eservisnaknjiga_admin/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class PackageListScreen extends StatefulWidget {
  const PackageListScreen({super.key});

  @override
  State<PackageListScreen> createState() => _PackageListScreenState();
}

class _PackageListScreenState extends State<PackageListScreen> {
  Package? package;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late PackageProvider _packageProvider;
  late TextEditingController dateController = TextEditingController();
  late TextEditingController _nazivController;
  late TextEditingController _opisController;
  late TextEditingController _minController;
  late TextEditingController _maxController;
  late TextEditingController _intervalController;
  bool isDateFieldEnabled = true;
  SearchResult<Package>? result;

  @override
  void initState() {
    super.initState();

    _nazivController = TextEditingController();
    _opisController = TextEditingController();
    _maxController = TextEditingController();
    _minController = TextEditingController();
    _intervalController = TextEditingController();
  }

  @override
  void dispose() {
    _nazivController.dispose();
    _opisController.dispose();
    _minController.dispose();
    _maxController.dispose();
    _intervalController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _packageProvider = context.read<PackageProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Paketi",
      child: Container(
        child: Column(children: [_buildSearch(), _buildDataListView()]),
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
            decoration: const InputDecoration(labelText: "Naziv"),
            controller: _nazivController,
          )),
          const SizedBox(
            height: 8,
            width: 10,
          ),
          Expanded(
              child: TextField(
            decoration: const InputDecoration(labelText: "Opis"),
            controller: _opisController,
          )),
          const SizedBox(
            height: 8,
            width: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                var data = await _packageProvider.get(filter: {
                  'naziv': _nazivController.text,
                  'opis': _opisController.text
                });
                setState(() {
                  result = data;
                });
                //print("data: ${data.result[0].id}");
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Pretraga'),
                  SizedBox(width: 8),
                  Icon(Icons.search_outlined),
                ],
              )),
          const SizedBox(
            height: 8,
            width: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                _updateText();
                //print("data: ${data.result[0].id}");
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Dodaj novi paket'),
                  SizedBox(width: 8),
                  Icon(Icons.add),
                ],
              )),
          const SizedBox(
            height: 8,
            width: 10,
          )
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
                          label: Expanded(
                              child: Text(
                        'Naziv',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ))),
                      DataColumn(
                          label: Expanded(
                              child: Text(
                        'Opis',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ))),
                      DataColumn(
                          label: Expanded(
                              child: Text(
                        'Raspon cijene',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ))),
                      DataColumn(
                          label: Expanded(
                              child: Text(
                        'Interval',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ))),
                      DataColumn(
                          label: Expanded(
                              child: Text(
                        'Slika',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ))),
                      DataColumn(
                          label: Expanded(
                              child: Text(
                        'Izmjeni',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ))),
                      DataColumn(
                          label: Expanded(
                              child: Text(
                        'Obrisi',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      )))
                    ],
                    rows: result?.result
                            .map((e) => DataRow(cells: [
                                  DataCell(Text(e.naziv ?? "")),
                                  DataCell(
                                    SizedBox(
                                      width: double
                                          .infinity, // Ensures the SingleChildScrollView takes the full width of the cell
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(e.opis ?? ""),
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(
                                      ("${e.minimalnaCijena ?? ""} - ") +
                                          (e.maksimalnaCijena?.toString() ??
                                              ""))),
                                  DataCell(Text(e.intervalObavjesti ?? "Nema")),
                                  DataCell(SizedBox(
                                    width: 80,
                                    child: e.slika != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child:
                                                imageFromBase64String(e.slika!))
                                        : Container(
                                            alignment: Alignment.center,
                                            child: const Text(
                                                "Slika nije dostupna"),
                                          ),
                                  )),
                                  DataCell(ElevatedButton(
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween, // Aligns the text to the start and the icon to the end
                                      children: [
                                        Text('Izmjeni '),
                                        Icon(Icons
                                            .edit_outlined), // Your desired icon
                                      ],
                                    ),
                                    onPressed: () {
                                      _updateText(package: e);
                                    },
                                  )),
                                  DataCell(ElevatedButton(
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween, // Aligns the text to the start and the icon to the end
                                      children: [
                                        Text('Obrisi '),
                                        Icon(Icons
                                            .edit_outlined), // Your desired icon
                                      ],
                                    ),
                                    onPressed: () async {
                                      await _packageProvider.delete(e.id!);
                                      var data = await _packageProvider.get(
                                          filter: {
                                            'naziv': _nazivController.text,
                                            'opis': _opisController.text
                                          });
                                      setState(() {
                                        result = data;
                                      });
                                    },
                                  ))
                                ]))
                            .toList() ??
                        []))));
  }

  void _openPopup(BuildContext context, Package? package) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Stack(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FormBuilderTextField(
                        name: 'naziv',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Polje je mandatorno"),
                        ]),
                        decoration: const InputDecoration(
                          labelText: 'Naziv',
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(10.0)),
                      FormBuilderTextField(
                        name: 'opis',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Polje je mandatorno"),
                        ]),
                        decoration: InputDecoration(
                          labelText: 'Opis',
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 25.0,
                            horizontal: 12.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 22.0,
                        ),
                        minLines: 3,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                      const Padding(padding: EdgeInsets.all(10.0)),
                      FormBuilderSlider(
                        name: 'minimalnaCijena',
                        initialValue: 250.00,
                        min: 50.00,
                        max: 450.00,
                        divisions: 10,
                        decoration: const InputDecoration(
                          labelText: 'Minimalna cijena',
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(10.0)),
                      FormBuilderSlider(
                        name: 'maksimalnaCijena',
                        initialValue: 750.00,
                        min: 500.00,
                        max: 1000.00,
                        divisions: 10,
                        decoration: const InputDecoration(
                          labelText: 'Maksimalna cijena',
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(10.0)),
                      FormBuilderDropdown(
                        name: 'intervalObavjesti',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Polje je mandatorno"),
                        ]),
                        decoration: const InputDecoration(
                          labelText: 'Interval',
                        ),
                        items: ['12', '24', '36', 'Nema']
                            .map((interval) => DropdownMenuItem(
                                  value: interval,
                                  child: Text(interval),
                                ))
                            .toList(),
                      ),
                      FormBuilderField(
                          builder: (((field) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                  label: const Text('Slika'),
                                  errorText: field.errorText),
                              child: ListTile(
                                leading: const Icon(Icons.photo),
                                title: const Text("Odaberite sliku"),
                                trailing: Icon(Icons.file_upload),
                                onTap: getImage,
                              ),
                            );
                          })),
                          name: 'slika'),
                      const Padding(padding: EdgeInsets.all(10.0)),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.saveAndValidate();

                            var request =
                                new Map.from(_formKey.currentState!.value);

                            request['slika'] = _base64Image;
                            try {
                              if (package == null) {
                                await _packageProvider.insert(request);
                              } else {
                                await _packageProvider.update(
                                    package!.id!, request);
                              }
                              package = null;
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
                        child: Text(
                          package == null
                              ? "Dodaj novi paket"
                              : "Izmjeni paket",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  File? _image;
  String? _base64Image;

  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
    }
  }

  Future<void> _updateText({package}) async => setState(() {
        _initialValue = {
          if (package != null) 'naziv': package.naziv ?? '' else 'naziv': '',
          if (package != null) 'opis': package.opis ?? '' else 'opis': '',
          if (package != null)
            'minimalnaCijena': package.minimalnaCijena?.toString() ?? ''
          else
            'minimalnaCijena': '',
          if (package != null)
            'maksimalnaCijena': package.maksimalnaCijena?.toString() ?? ''
          else
            'maksimalnaCijena': '',
          if (package != null)
            'intervalObavjesti': package.intervalObavjesti ?? ''
          else
            'intervalObavjesti': ''
        };
        _openPopup(context, package);
      });
}
