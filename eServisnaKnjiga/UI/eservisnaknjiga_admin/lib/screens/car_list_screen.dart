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

class CarListScreen extends StatefulWidget {
  final Client? client; // opcionalni parametar za filtriranje po klijentu

  const CarListScreen({super.key, this.client});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  late CarProvider _carProvider;
  late ClientProvider _clientProvider;
  SearchResult<Car>? result;
  List<Client> _clients = [];

  final _formKey = GlobalKey<FormBuilderState>();

  // filter polja
  TextEditingController _markaController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _registracijaController = TextEditingController();
  TextEditingController _brojSasijeController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carProvider = context.read<CarProvider>();
    _clientProvider = context.read<ClientProvider>();
    _loadClients();
    _loadCars();
  }

  Future<void> _loadClients() async {
    var clientsRes = await _clientProvider.get();
    setState(() {
      _clients = clientsRes.result;
    });
  }

  Future<void> _loadCars({Map<String, dynamic>? extraFilter}) async {
    Map<String, dynamic> filter = {
      'marka': _markaController.text,
      'model': _modelController.text,
      'registracija': _registracijaController.text,
      'brojSasije': _brojSasijeController.text,
      if (widget.client != null) 'clientId': widget.client!.id,
      if (extraFilter != null) ...extraFilter,
    };

    var carsRes = await _carProvider.get(filter: filter);
    setState(() {
      result = carsRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.client != null
          ? "Automobili klijenta ${widget.client!.ime} ${widget.client!.prezime}"
          : "Automobili",
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
          Flexible(
            flex: 1,
            child: TextField(
              decoration: const InputDecoration(labelText: "Marka"),
              controller: _markaController,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 1,
            child: TextField(
              decoration: const InputDecoration(labelText: "Model"),
              controller: _modelController,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 1,
            child: TextField(
              decoration: const InputDecoration(labelText: "Registracija"),
              controller: _registracijaController,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 1,
            child: TextField(
              decoration: const InputDecoration(labelText: "Broj šasije"),
              controller: _brojSasijeController,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _loadCars(),
            child: const Text("Pretraga"),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => _openPopup(context, null),
            icon: const Icon(Icons.add),
            label: const Text("Dodaj automobil"),
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
            columns: const [
              DataColumn(label: Text("Marka")),
              DataColumn(label: Text("Model")),
              DataColumn(label: Text("Godina")),
              DataColumn(label: Text("Registracija")),
              DataColumn(label: Text("Broj šasije")),
              DataColumn(label: Text("Klijent")),
              DataColumn(label: Text("Izmjeni")),
            ],
            rows: result?.result
                    .map(
                      (car) => DataRow(cells: [
                        DataCell(Text(car.marka ?? "")),
                        DataCell(Text(car.model ?? "")),
                        DataCell(Text(car.godinaProizvodnje?.toString() ?? "")),
                        DataCell(Text(car.registracija ?? "")),
                        DataCell(Text(car.brojSasije ?? "")),
                        DataCell(Text(
                            "${car.klijent?.ime ?? ""} ${car.klijent?.prezime ?? ""}")),
                        DataCell(
                          ElevatedButton(
                            onPressed: () => _openPopup(context, car),
                            child: const Row(
                              children: [
                                Text("Izmjeni"),
                                Icon(Icons.edit),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    )
                    .toList() ??
                [],
          ),
        ),
      ),
    );
  }

  void _openPopup(BuildContext context, Car? car) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: FormBuilder(
          key: _formKey,
          initialValue: {
            'marka': car?.marka ?? '',
            'model': car?.model ?? '',
            'godina': car?.godinaProizvodnje?.toString() ?? '',
            'registracija': car?.registracija ?? '',
            'brojSasije': car?.brojSasije ?? '',
            'clientId': car?.klijent?.id ?? widget.client?.id,
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBuilderTextField(
                  name: 'marka',
                  decoration: const InputDecoration(labelText: "Marka"),
                  validator: FormBuilderValidators.required(
                      errorText: "Marka je obavezna"),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'model',
                  decoration: const InputDecoration(labelText: "Model"),
                  validator: FormBuilderValidators.required(
                      errorText: "Model je obavezan"),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'godina',
                  decoration: const InputDecoration(labelText: "Godina"),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Godina je obavezna";
                    final year = int.tryParse(val);
                    final currentYear = DateTime.now().year;
                    if (year == null) return "Unesite ispravan broj";
                    if (year > currentYear)
                      return "Godina ne može biti veća od trenutne";
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'registracija',
                  decoration: const InputDecoration(labelText: "Registracija"),
                  validator: FormBuilderValidators.required(
                      errorText: "Registracija je obavezna"),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'brojSasije',
                  decoration: const InputDecoration(labelText: "Broj šasije"),
                  validator: FormBuilderValidators.required(
                      errorText: "Broj šasije je obavezan"),
                ),
                const SizedBox(height: 10),
                FormBuilderDropdown<int>(
                  name: 'clientId',
                  decoration: const InputDecoration(labelText: 'Klijent'),
                  initialValue: car?.klijent?.id ?? widget.client?.id,
                  enabled: widget.client == null,
                  items: _clients
                      .map((c) => DropdownMenuItem(
                            value: c.id,
                            child: Text("${c.ime} ${c.prezime}"),
                          ))
                      .toList(),
                  validator: FormBuilderValidators.required(
                      errorText: 'Klijent je obavezan'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      var data = Map<String, dynamic>.from(
                          _formKey.currentState!.value);

                      // mapiranje u nazive koje backend očekuje
                      data['godinaProizvodnje'] =
                          int.tryParse(data['godina'].toString());
                      data['klijentId'] = data['clientId'] ?? widget.client?.id;

                      data.remove('godina');
                      data.remove('clientId');

                      try {
                        if (car == null) {
                          await _carProvider.insert(data);
                        } else {
                          await _carProvider.update(car.id!, data);
                        }
                        Navigator.pop(context);
                        _loadCars();
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Greška"),
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
                      car == null ? "Dodaj automobil" : "Izmjeni automobil"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
