import 'package:eservisnaknjiga_admin/models/repairman.dart';
import 'package:eservisnaknjiga_admin/models/search_result.dart';
import 'package:eservisnaknjiga_admin/providers/repairman_provider.dart';
import 'package:eservisnaknjiga_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RepairmanListScreen extends StatefulWidget {
  const RepairmanListScreen({super.key});

  @override
  State<RepairmanListScreen> createState() => _RepairmanListScreenState();
}

class _RepairmanListScreenState extends State<RepairmanListScreen> {
  Repairman? repairman;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late RepairmanProvider _repairmanProvider;
  late TextEditingController dateController = TextEditingController();
  late TextEditingController _imeController;
  late TextEditingController _prezimeController;
  bool isDateFieldEnabled = true;
  SearchResult<Repairman>? result;

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
    _repairmanProvider = context.read<RepairmanProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Majstori",
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
              var data = await _repairmanProvider.get(filter: {
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
                Icon(Icons.person_search_outlined),
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
                Text('Dodaj novog'),
                SizedBox(width: 8),
                Icon(Icons.person_add_alt),
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
        child: DataTable(
          columns: const [
            DataColumn(
                label:
                    Text('Ime', style: TextStyle(fontStyle: FontStyle.italic))),
            DataColumn(
                label: Text('Prezime',
                    style: TextStyle(fontStyle: FontStyle.italic))),
            DataColumn(
                label: Text('Datum Rođenja',
                    style: TextStyle(fontStyle: FontStyle.italic))),
            DataColumn(
                label: Text('Izmjeni',
                    style: TextStyle(fontStyle: FontStyle.italic))),
          ],
          rows: result?.result
                  .map((e) => DataRow(
                        cells: [
                          DataCell(Text(e.ime ?? "")),
                          DataCell(Text(e.prezime ?? "")),
                          DataCell(
                              Text(e.datumRodjenja?.substring(0, 10) ?? "")),
                          DataCell(
                            ElevatedButton(
                              onPressed: () {
                                _updateText(repairman: e);
                              },
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Izmjeni'),
                                  Icon(Icons.edit_outlined),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))
                  .toList() ??
              [],
        ),
      ),
    );
  }

  void _openPopup(BuildContext context, Repairman? repairman) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Stack(
            clipBehavior: Clip.none,
            children: [
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
                  children: [
                    FormBuilderTextField(
                      name: 'ime',
                      decoration: const InputDecoration(labelText: 'Ime'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Ime je obavezno'),
                        FormBuilderValidators.match(
                          r'^[A-Za-zÀ-ÿ\s]{2,}$',
                          errorText:
                              'Ime može sadržavati samo slova i mora imati barem 2 znaka',
                        ),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'prezime',
                      decoration: const InputDecoration(labelText: 'Prezime'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Prezime je obavezno'),
                        FormBuilderValidators.match(
                          r'^[A-Za-zÀ-ÿ\s\-]{2,}$',
                          errorText:
                              'Prezime može sadržavati samo slova, razmake i crtice (min 2 znaka)',
                        ),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'datumrodjenja',
                      controller: dateController,
                      enabled: isDateFieldEnabled,
                      decoration:
                          const InputDecoration(labelText: 'Datum rođenja'),
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Datum rođenja je obavezan';
                        }
                        try {
                          final date =
                              DateFormat('yyyy-MM-dd').parseStrict(value);
                          if (date.isAfter(DateTime.now())) {
                            return 'Datum rođenja ne može biti u budućnosti';
                          }
                          if (date.isBefore(DateTime.now()
                              .subtract(const Duration(days: 365 * 120)))) {
                            return 'Datum rođenja nije realan (više od 120 godina)';
                          }
                        } catch (_) {
                          return 'Neispravan format datuma';
                        }
                        return null;
                      },
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          dateController.text = formattedDate;
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          try {
                            if (repairman == null) {
                              await _repairmanProvider
                                  .insert(_formKey.currentState?.value);
                            } else {
                              await _repairmanProvider.update(
                                  repairman!.id!, _formKey.currentState?.value);
                            }
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
                      child: Text(repairman == null
                          ? "Dodaj novog majstora"
                          : "Izmjeni majstora"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateText({repairman}) async {
    setState(() {
      _initialValue = {
        'ime': repairman?.ime ?? '',
        'prezime': repairman?.prezime ?? '',
        'datumrodjenja': repairman?.datumRodjenja ?? null,
      };
      if (repairman != null && repairman.datumRodjenja != null) {
        dateController.text =
            repairman.datumRodjenja.toString().substring(0, 10);
        isDateFieldEnabled = false;
      } else {
        isDateFieldEnabled = true;
        dateController.text = "";
      }
      _openPopup(context, repairman);
    });
  }
}
