import 'package:eservisnaknjiga_mobile/models/search_result.dart';
import 'package:eservisnaknjiga_mobile/models/work_order.dart';
import 'package:eservisnaknjiga_mobile/providers/work_order_provider.dart';
import 'package:eservisnaknjiga_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CarServiceListScreen extends StatefulWidget {
  final int carId;
  const CarServiceListScreen({super.key, required this.carId});

  @override
  State<CarServiceListScreen> createState() => _CarServiceListScreenState();
}

class _CarServiceListScreenState extends State<CarServiceListScreen> {
  late WorkOrderProvider _workOrderProvider;
  SearchResult<WorkOrder>? _services;
  late DateFormat dateFormatter;

  @override
  void initState() {
    super.initState();
    dateFormatter = DateFormat("dd.MM.yyyy. HH:mm", "sr");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _workOrderProvider = context.read<WorkOrderProvider>();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var data = await _workOrderProvider.getCarServiceList(widget.carId);
    setState(() {
      _services = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Servisi automobila",
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.redAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _services == null
            ? const Center(child: CircularProgressIndicator())
            : _services!.result.isEmpty
                ? const Center(
                    child: Text(
                      "Nema servisa za ovaj automobil.",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: _services!.result.length,
                    itemBuilder: (context, index) {
                      var service = _services!.result[index];
                      var paketi = service.rezervacija?.rezervacijaPaketi ?? [];

                      String datumRez = service.rezervacija?.datum != null
                          ? dateFormatter.format(service.rezervacija!.datum!)
                          : "Nepoznato";

                      return Card(
                        margin: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.opis ?? "Opis nije dostupan",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text("Datum rezervacije: $datumRez"),
                              Text("Cijena: ${service.cijena ?? 0} KM"),
                              const SizedBox(height: 8),
                              Text(
                                "Majstor: ${service.majstor?.ime ?? ""} ${service.majstor?.prezime ?? ""}",
                              ),
                              const Divider(height: 20, thickness: 1),
                              const Text(
                                "Paketi:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              paketi.isEmpty
                                  ? const Text("Nema paketa za ovaj servis.")
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: paketi.map((rp) {
                                        var paket = rp.paket;
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                paket?.naziv ??
                                                    "Naziv paketa nije dostupan",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              if (paket?.opis != null)
                                                Text("Opis: ${paket!.opis}"),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
