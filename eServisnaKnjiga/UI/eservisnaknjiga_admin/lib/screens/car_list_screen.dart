import 'package:eservisnaknjiga_admin/models/car.dart';
import 'package:eservisnaknjiga_admin/models/search_result.dart';
import 'package:eservisnaknjiga_admin/providers/car_provider.dart';
import 'package:eservisnaknjiga_admin/screens/car_detail_screen.dart';
import 'package:eservisnaknjiga_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  late CarProvider _carProvider;
  SearchResult<Car>? result;

  TextEditingController _markaController = new TextEditingController();
  TextEditingController _modelController = new TextEditingController();
  TextEditingController _registracijaController = new TextEditingController();
  TextEditingController _brojSasijeController = new TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _carProvider = context.read<CarProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Automobili",
      child: Column(children: [_buildSearch(), _buildDataListView()]),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            decoration: const InputDecoration(labelText: "Marka"),
            controller: _markaController,
          )),
          const SizedBox(
            height: 8,
            width: 10,
          ),
          Expanded(
              child: TextField(
            decoration: const InputDecoration(labelText: "Model"),
            controller: _modelController,
          )),
          const SizedBox(
            height: 8,
            width: 10,
          ),
          Expanded(
              child: TextField(
            decoration: const InputDecoration(labelText: "Registracija"),
            controller: _registracijaController,
          )),
          const SizedBox(
            height: 8,
            width: 10,
          ),
          Expanded(
              child: TextField(
            decoration: const InputDecoration(labelText: "Broj sasije"),
            controller: _brojSasijeController,
          )),
          ElevatedButton(
              onPressed: () async {
                var data = await _carProvider.get(filter: {
                  'model': _modelController.text,
                  'marka': _markaController.text,
                  'registracija': _registracijaController.text,
                  'brojSasije': _markaController.text
                });
                setState(() {
                  result = data;
                });
                //print("data: ${data.result[0].id}");
              },
              child: const Text("Pretraga")),
          const SizedBox(
            height: 8,
            width: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CarDetailScreen(car: null)));
                //print("data: ${data.result[0].id}");
              },
              child: const Text("Dodaj"))
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
              label: Expanded(
                  child: Text(
            'Marka',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          DataColumn(
              label: Expanded(
                  child: Text(
            'Model',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          DataColumn(
              label: Expanded(
                  child: Text(
            'Godiste',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          DataColumn(
              label: Expanded(
                  child: Text(
            'Registarske oznake',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          DataColumn(
              label: Expanded(
                  child: Text(
            'Broj sasije',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          DataColumn(
              label: Expanded(
                  child: Text(
            'Klijent',
            style: TextStyle(fontStyle: FontStyle.italic),
          )))
        ],
                rows: result?.result
                        .map((e) => DataRow(
                                onSelectChanged: (selected) => {
                                      if (selected == true)
                                        {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CarDetailScreen(car: e))),
                                        }
                                    },
                                cells: [
                                  DataCell(Text(e.marka ?? "")),
                                  DataCell(Text(e.model ?? "")),
                                  DataCell(Text(
                                      e.godinaProizvodnje?.toString() ?? "")),
                                  DataCell(Text(e.registracija ?? "")),
                                  DataCell(Text(e.brojSasije ?? "")),
                                  DataCell(
                                      Text(e.klijent?.ime?.toString() ?? "")),
                                ]))
                        .toList() ??
                    [])));
  }
}
