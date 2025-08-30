import 'package:eservisnaknjiga_mobile/models/rezervation.dart';
import 'package:eservisnaknjiga_mobile/providers/rezervation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/master_screen.dart';
import 'package:intl/intl.dart';

class HistoryReservationList extends StatefulWidget {
  const HistoryReservationList({Key? key}) : super(key: key);

  @override
  State<HistoryReservationList> createState() => _HistoryReservationListState();
}

class _HistoryReservationListState extends State<HistoryReservationList> {
  late RezervationProvider _reservationProvider;
  List<Rezervation> _reservations = [];
  bool _isLoading = true;
  late DateFormat dateFormatter;

  final Map<String, String> statusi = {
    "initial": "Inicijalna",
    "created": "Kreirana",
    "accepted": "Prihvaćena",
    "modify": "Čeka potvrdu",
    "canceled": "Otkazana",
    "paid_cash": "Plaćeno gotovinom",
    "pending_payment": "Čeka uplatu",
    "paid_mpay": "Plaćeno karticom",
  };

  @override
  void initState() {
    super.initState();
    dateFormatter = DateFormat("dd.MM.yyyy. HH:mm", "sr");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reservationProvider = context.read<RezervationProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var result = await _reservationProvider.getReservationListForClient(1);
      result.sort((a, b) => b.datum!.compareTo(a.datum!));

      setState(() {
        _reservations = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Greška: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Moje rezervacije",
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildReservationListView(),
        ),
      ),
    );
  }

  Widget _buildReservationListView() {
    if (_reservations.isEmpty) {
      return const Center(
        child: Text(
          "Nema rezervacija",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: _reservations.length,
      itemBuilder: (context, index) {
        final rez = _reservations[index];

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
                  "Rezervacija status: ${statusi[rez.status] ?? rez.status}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Datum: ${dateFormatter.format(rez.datum!)}\n"
                  "Opis: ${rez.opis}\n"
                  "Auto: ${rez.automobil?.marka ?? ""} ${rez.automobil?.model ?? ""}",
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 12),
                if (rez.status == "modify")
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await _reservationProvider.setState(
                                rez.id!, "Accepted");
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Termin je uspješno prihvaćen!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                            _loadData();
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Greška prilikom prihvatanja termina: $e"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Prihvati",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildCancelButton(rez),
                    ],
                  )
                else if (rez.status == "created" || rez.status == "accepted")
                  _buildCancelButton(rez),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCancelButton(Rezervation rez) {
    return ElevatedButton(
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Potvrda"),
            content:
                const Text("Da li ste sigurni da želite otkazati rezervaciju?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Ne"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Da"),
              ),
            ],
          ),
        );

        if (confirm == true) {
          try {
            await _reservationProvider.setState(rez.id!, "Canceled");
            _loadData();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Rezervacija je uspješno otkazana."),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Greška prilikom otkazivanja: $e"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        "Otkaži",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
