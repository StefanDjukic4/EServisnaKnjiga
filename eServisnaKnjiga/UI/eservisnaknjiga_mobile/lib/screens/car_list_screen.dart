import 'package:eservisnaknjiga_mobile/models/car.dart';
import 'package:eservisnaknjiga_mobile/models/search_result.dart';
import 'package:eservisnaknjiga_mobile/providers/car_provider.dart';
import 'package:eservisnaknjiga_mobile/screens/car_service_list_screen.dart';
import 'package:eservisnaknjiga_mobile/widgets/master_screen.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carProvider = context.read<CarProvider>();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var data = await _carProvider.getById(56);
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Vaši Automobili",
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
                  : Expanded(child: _buildCarsListView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarsListView() {
    var carList = result?.result ?? [];
    return ListView.builder(
      itemCount: carList.length,
      itemBuilder: (context, index) {
        var carsItem = carList[index];
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
                  'Marka: ${carsItem.marka ?? "Marka nije dostupna"}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Model: ${carsItem.model ?? "Model nije dostupan"}'),
                const SizedBox(height: 8),
                Text(
                    'Godište: ${carsItem.godinaProizvodnje ?? "Nije dostupno"}'),
                const SizedBox(height: 8),
                Text(
                    'Registracija: ${carsItem.registracija ?? "Nije dostupna"}'),
                const SizedBox(height: 8),
                Text('Broj šasije: ${carsItem.brojSasije ?? "Nije dostupna"}'),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CarServiceListScreen(carId: carsItem.id!),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Pregled servisa"),
                  ),
                ),
              ],
            ),
          ),
        );
        ;
      },
    );
  }
}
