import 'package:eservisnaknjiga_admin/models/car.dart';
import 'package:eservisnaknjiga_admin/models/client.dart';
import 'package:eservisnaknjiga_admin/models/search_result.dart';
import 'package:eservisnaknjiga_admin/providers/car_provider.dart';
import 'package:eservisnaknjiga_admin/providers/client_provider.dart';
import 'package:eservisnaknjiga_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  Client? client;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late ClientProvider _clientProvider;
  late CarProvider _carProvider;
  late TextEditingController dateController = TextEditingController();
  late TextEditingController _imeController;
  late TextEditingController _prezimeController;
  bool isNameSurnameFieldEnabled = true;
  SearchResult<Client>? result;

  @override
  void initState() {
    super.initState();
    _imeController = TextEditingController();
    _prezimeController = TextEditingController();
  }

  @override
  void dispose() {
    _imeController.dispose();
    _prezimeController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _clientProvider = context.read<ClientProvider>();
    _carProvider = context.read<CarProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Klijenti",
      child: Column(
        children: [_buildSearch(), _buildDataListView()],
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
              decoration: const InputDecoration(labelText: "Ime"),
              controller: _imeController,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(labelText: "Prezime"),
              controller: _prezimeController,
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () async {
              var data = await _clientProvider.get(filter: {
                'ime': _imeController.text,
                'prezime': _prezimeController.text
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
            onPressed: () async {
              _updateText();
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Dodaj novog klijenta'),
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
                  label: Text('Ime',
                      style: TextStyle(fontStyle: FontStyle.italic))),
              DataColumn(
                  label: Text('Prezime',
                      style: TextStyle(fontStyle: FontStyle.italic))),
              DataColumn(
                  label: Text('Telefon',
                      style: TextStyle(fontStyle: FontStyle.italic))),
              DataColumn(
                  label: Text('Adresa',
                      style: TextStyle(fontStyle: FontStyle.italic))),
              DataColumn(
                  label: Text('E-Mail',
                      style: TextStyle(fontStyle: FontStyle.italic))),
              DataColumn(
                  label: Text('Izmjeni',
                      style: TextStyle(fontStyle: FontStyle.italic))),
            ],
            rows: result?.result
                    .map(
                      (e) => DataRow(
                        cells: [
                          DataCell(Text(e.ime ?? "")),
                          DataCell(Text(e.prezime ?? "")),
                          DataCell(Text(e.telefon ?? "")),
                          DataCell(Text(e.adresa ?? "")),
                          DataCell(Text(e.email ?? "")),
                          DataCell(
                            ElevatedButton(
                              child: const Row(
                                children: [
                                  Text('Izmjeni '),
                                  Icon(Icons.edit_outlined),
                                ],
                              ),
                              onPressed: () {
                                _updateText(client: e);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList() ??
                [],
          ),
        ),
      ),
    );
  }

  void _openPopup(BuildContext context, Client? client) {
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
                        name: 'ime',
                        enabled: isNameSurnameFieldEnabled,
                        decoration: const InputDecoration(labelText: 'Ime'),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Ime je obavezno'),
                          FormBuilderValidators.minLength(2,
                              errorText: 'Ime mora imati barem 2 slova'),
                        ]),
                      ),
                      const Padding(padding: EdgeInsets.all(10.0)),
                      FormBuilderTextField(
                        name: 'prezime',
                        enabled: isNameSurnameFieldEnabled,
                        decoration: const InputDecoration(labelText: 'Prezime'),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Prezime je obavezno'),
                          FormBuilderValidators.minLength(2,
                              errorText: 'Prezime mora imati barem 2 slova'),
                        ]),
                      ),
                      const Padding(padding: EdgeInsets.all(10.0)),
                      FormBuilderTextField(
                        name: 'telefon',
                        decoration: const InputDecoration(labelText: 'Telefon'),
                        validator: (value) {
                          final trimmed = value?.trim() ?? '';
                          if (trimmed.isEmpty) return 'Telefon je obavezan';
                          final regex = RegExp(r'^\+[0-9]{7,}$');
                          if (!regex.hasMatch(trimmed)) {
                            return 'Broj mora početi sa + i imati samo cifre (min 7 nakon +)';
                          }
                          return null;
                        },
                      ),
                      const Padding(padding: EdgeInsets.all(10.0)),
                      FormBuilderTextField(
                        name: 'adresa',
                        decoration: const InputDecoration(labelText: 'Adresa'),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Adresa je obavezna'),
                        ]),
                      ),
                      const Padding(padding: EdgeInsets.all(10.0)),
                      FormBuilderTextField(
                        name: 'email',
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Email je obavezan'),
                          FormBuilderValidators.email(
                              errorText: 'Unesite ispravan email'),
                        ]),
                      ),
                      const Padding(padding: EdgeInsets.all(10.0)),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.saveAndValidate() ??
                              false) {
                            try {
                              if (client == null) {
                                await _clientProvider
                                    .insert(_formKey.currentState?.value);
                              } else {
                                await _clientProvider.update(
                                    client!.id!, _formKey.currentState?.value);
                              }
                              client = null;
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
                        child: Text(client == null
                            ? "Dodaj novog klijenta"
                            : "Izmjeni klijenta"),
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

  Future<void> _updateText({client}) async => setState(() {
        _initialValue = {
          if (client != null) 'ime': client.ime ?? '' else 'ime': '',
          if (client != null)
            'prezime': client.prezime ?? ''
          else
            'prezime': '',
          if (client != null) 'adresa': client.adresa ?? '' else 'adresa': '',
          if (client != null) 'email': client.email ?? '' else 'email': '',
          if (client != null)
            'telefon': client.telefon ?? ''
          else
            'telefon': '',
        };
        if (client != null && client.ime != null) {
          isNameSurnameFieldEnabled = false;
        } else {
          isNameSurnameFieldEnabled = true;
        }
        _openPopup(context, client);
      });
}
