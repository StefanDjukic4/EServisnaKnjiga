import 'package:eservisnaknjiga_mobile/models/car.dart';
import 'package:eservisnaknjiga_mobile/models/packages.dart';
import 'package:eservisnaknjiga_mobile/models/rezervation.dart';
import 'package:eservisnaknjiga_mobile/models/search_result.dart';
import 'package:eservisnaknjiga_mobile/providers/car_provider.dart';
import 'package:eservisnaknjiga_mobile/providers/packages_provider.dart';
import 'package:eservisnaknjiga_mobile/providers/rezervation_provider.dart';
import 'package:eservisnaknjiga_mobile/screens/packages_list_screen.dart';
import 'package:eservisnaknjiga_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReservationListScreen extends StatefulWidget {
  final List<Packages>? selectedPackages;
  const ReservationListScreen({Key? key, this.selectedPackages})
      : super(key: key);

  @override
  State<ReservationListScreen> createState() => _ReservationListScreenState();
}

class _ReservationListScreenState extends State<ReservationListScreen> {
  late CarProvider _carProvider;
  late RezervationProvider _rezervationProvider;
  late PackagesProvider _packagesProvider;

  SearchResult<Car>? carResult;
  int? selectedCarId;
  List<String> selectedServices = [];
  List<int> selectedPackagesId = [];
  DateTime? selectedDateTime;
  String? opis;

  List<Packages> recommendedPackages = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carProvider = context.read<CarProvider>();
    _rezervationProvider = context.read<RezervationProvider>();
    _packagesProvider = context.read<PackagesProvider>();

    _fetchData();

    if (widget.selectedPackages != null &&
        widget.selectedPackages!.isNotEmpty) {
      selectedServices = widget.selectedPackages!
          .map((package) => package.naziv ?? "")
          .toList();
      selectedPackagesId =
          widget.selectedPackages!.map((package) => package.id!).toList();

      // Poziv preporučenih paketa
      _fetchRecommendedPackages(widget.selectedPackages!.first.id!);
    }
  }

  Future<void> _fetchData() async {
    var carData = await _carProvider.getById(1);
    setState(() {
      carResult = carData;
    });
  }

  Future<void> _fetchRecommendedPackages(int packageId) async {
    try {
      var result = await _packagesProvider.recommend(packageId);
      setState(() {
        recommendedPackages = result;
      });
    } catch (e) {
      debugPrint("Greška pri dohvatu preporuka: $e");
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submitForm() {
    if (selectedCarId != null &&
        selectedServices.isNotEmpty &&
        selectedDateTime != null) {
      Rezervation rezervation = Rezervation(
        selectedCarId,
        selectedDateTime,
        opis,
        selectedPackagesId,
      );
      _rezervationProvider.insert(rezervation);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rezervacija uspješno kreirana!")),
      );

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          selectedCarId = null;
          selectedServices.clear();
          selectedPackagesId.clear();
          selectedDateTime = null;
          opis = null;
        });

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ReservationListScreen(),
        ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Molimo popunite sva polja.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Rezervacija termina",
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Podaci o rezervaciji",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    if (widget.selectedPackages == null ||
                        widget.selectedPackages!.isEmpty)
                      Column(
                        children: [
                          const Text(
                            "Molimo da odaberete pakete prije nego nastavite rezervaciju.",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PackagesListScreen(),
                              ));
                            },
                            child: const Text("Lista paketa u ponudi"),
                          ),
                        ],
                      ),
                    if (widget.selectedPackages != null &&
                        widget.selectedPackages!.isNotEmpty)
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButtonFormField<int>(
                                  decoration: const InputDecoration(
                                      labelText: "Odaberite vozilo"),
                                  value: selectedCarId,
                                  items: carResult?.result.map((car) {
                                    return DropdownMenuItem(
                                      value: car.id,
                                      child: Text(
                                        "${car.model ?? "Model nije dostupan"} - ${car.registracija ?? "Registracija nije dostupna"}",
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCarId = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: "Odabrani paketi",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Column(
                                    children: (widget.selectedPackages ?? [])
                                        .map((package) {
                                      return CheckboxListTile(
                                        title: Text(
                                          "${package.naziv ?? "Naziv nije dostupan"} - ${package.minimalnaCijena?.toStringAsFixed(2) ?? "Cijena nije dostupna"} KM",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        value: selectedServices
                                            .contains(package.naziv),
                                        onChanged: (bool? selected) {
                                          setState(() {
                                            if (selected == true) {
                                              selectedServices
                                                  .add(package.naziv ?? "");
                                              selectedPackagesId
                                                  .add(package.id!);
                                            } else {
                                              selectedServices
                                                  .remove(package.naziv);
                                              selectedPackagesId
                                                  .remove(package.id!);
                                            }
                                          });
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (recommendedPackages.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Preporučeni paketi:",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ...recommendedPackages.map((package) {
                                        return ListTile(
                                          title: Text(package.naziv ?? ""),
                                          subtitle: Text(
                                              "${package.minimalnaCijena?.toStringAsFixed(2)} KM"),
                                          trailing: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                if (!selectedPackagesId
                                                    .contains(package.id)) {
                                                  selectedServices
                                                      .add(package.naziv ?? "");
                                                  selectedPackagesId
                                                      .add(package.id!);

                                                  if (widget.selectedPackages !=
                                                      null) {
                                                    widget.selectedPackages!
                                                        .add(package);
                                                  } else {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                      builder: (context) =>
                                                          ReservationListScreen(
                                                        selectedPackages: [
                                                          package
                                                        ],
                                                      ),
                                                    ));
                                                    return;
                                                  }

                                                  // Ukloni iz preporuka
                                                  recommendedPackages
                                                      .removeWhere((p) =>
                                                          p.id == package.id);
                                                }
                                              });
                                            },
                                            child: const Text("Dodaj"),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                const SizedBox(height: 10),
                                ListTile(
                                  title: Text(selectedDateTime == null
                                      ? "Odaberite datum i vrijeme"
                                      : "Datum i vrijeme: ${selectedDateTime!.toLocal()}"
                                          .split('.')[0]),
                                  trailing: const Icon(Icons.calendar_today),
                                  onTap: () => _selectDateTime(context),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: "Napomena",
                                    hintText: "Unesite napomenu",
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                  onChanged: (value) {
                                    setState(() {
                                      opis = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15),
                                      textStyle: const TextStyle(fontSize: 18),
                                    ),
                                    child: const Text("Rezerviši"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
