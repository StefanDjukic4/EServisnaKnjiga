import 'package:eservisnaknjiga_mobile/models/packages.dart';
import 'package:eservisnaknjiga_mobile/models/search_result.dart';
import 'package:eservisnaknjiga_mobile/providers/packages_provider.dart';
import 'package:eservisnaknjiga_mobile/screens/reservation_list.dart';
import 'package:eservisnaknjiga_mobile/utils/util.dart';
import 'package:eservisnaknjiga_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PackagesListScreen extends StatefulWidget {
  const PackagesListScreen({super.key});

  @override
  State<PackagesListScreen> createState() => _PackagesListScreenState();
}

class _PackagesListScreenState extends State<PackagesListScreen> {
  late PackagesProvider _packagesProvider;
  SearchResult<Packages>? result;
  List<Packages> _selectedPackages = []; // Lista odabranih paketa

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _packagesProvider = context.read<PackagesProvider>();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var data = await _packagesProvider.get();
    setState(() {
      result = data;
    });
  }

  void _addPackage(Packages package) {
    setState(() {
      _selectedPackages.add(package);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "Dodali ste paket: ${package.naziv}. Ukupno odabranih: ${_selectedPackages.length}"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Dostupni Paketi",
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: result == null
                  ? const Center(child: CircularProgressIndicator())
                  : _buildPackagesListView(),
            ),
            _buildSelectedPackagesFooter(), // Dodan footer za prikaz broja odabranih paketa
          ],
        ),
      ),
    );
  }

  Widget _buildPackagesListView() {
    var packageList = result?.result ?? [];
    return ListView.builder(
      itemCount: packageList.length,
      itemBuilder: (context, index) {
        var package = packageList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package.naziv ?? "Naziv nije dostupan",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  package.opis ?? "Opis nije dostupan",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  "Cijena: ${package.minimalnaCijena?.toInt() ?? 0} - ${package.maksimalnaCijena?.toInt() ?? 0} KM",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                package.slika != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: imageFromBase64String(package.slika!))
                    : Container(
                        width: double.infinity,
                        height: 150,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                        child: const Text("Slika nije dostupna"),
                      ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => _addPackage(package), // Poziv funkcije
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Odaberi paket",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedPackagesFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Broj odabranih paketa: ${_selectedPackages.length}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ReservationListScreen(selectedPackages: _selectedPackages),
              ));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Zakazi rezervaciju",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
