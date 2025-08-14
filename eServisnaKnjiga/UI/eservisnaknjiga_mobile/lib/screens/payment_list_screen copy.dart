import 'package:eservisnaknjiga_mobile/models/search_result.dart';
import 'package:eservisnaknjiga_mobile/models/work_order.dart';
import 'package:eservisnaknjiga_mobile/providers/rezervation_provider.dart';
import 'package:eservisnaknjiga_mobile/providers/work_order_provider.dart';
import 'package:eservisnaknjiga_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:provider/provider.dart';

class PaymentListScreen extends StatefulWidget {
  const PaymentListScreen({super.key});

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  late WorkOrderProvider _workOrderProvider;
  late RezervationProvider _rezervationProvider;
  SearchResult<WorkOrder>? result;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _workOrderProvider = context.read<WorkOrderProvider>();
    _rezervationProvider = context.read<RezervationProvider>();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var data = await _workOrderProvider.getById(1);
    setState(() {
      result = data;
    });
  }

  Future<void> _submitPayment(int rezervationId, double amount) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Potvrda plaćanja"),
        content: const Text("Da li ste sigurni da želite izvršiti plaćanje?"),
        actions: [
          TextButton(
            child: const Text("Otkaži"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            child: const Text("Plati"),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final response = await _rezervationProvider.initialzPayment(
        rezervationId,
        amount.toInt(),
      );

      final clientSecret = response;
      if (clientSecret.isEmpty) {
        throw Exception("Nema clientSecret u odgovoru.");
      }

      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Moja Aplikacija',
        ),
      );

      await stripe.Stripe.instance.presentPaymentSheet();

      await _rezervationProvider.successfulPayment(rezervationId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Plaćanje uspješno!")),
      );

      await _fetchData(); // Osvježi listu nakon plaćanja
    } on stripe.StripeException catch (e) {
      debugPrint("Stripe greška: ${e.error.localizedMessage}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Stripe greška: ${e.error.localizedMessage}")),
      );
    } catch (e) {
      debugPrint("Greška: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Greška pri plaćanju: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Dostupna M plaćanja",
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
                  : Expanded(child: _buildPaymentListView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentListView() {
    var paymentList = result?.result ?? [];
    return ListView.builder(
      itemCount: paymentList.length,
      itemBuilder: (context, index) {
        var paymentItem = paymentList[index];
        var paketi = paymentItem.rezervacija?.rezervacijaPaketi ?? [];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  "Cijena",
                  "${(paymentItem.cijena ?? 0).toStringAsFixed(2)} KM",
                ),
                _buildInfoRow(
                  "Datum rada",
                  paymentItem.datum?.toString().split(' ').first ?? "N/A",
                ),
                _buildInfoRow(
                  "Majstor",
                  "${paymentItem.majstor?.ime ?? "N/A"} ${paymentItem.majstor?.prezime ?? ""}",
                ),
                _buildInfoRow(
                  "Broj šasije",
                  paymentItem.rezervacija?.automobil?.brojSasije ?? "N/A",
                ),
                _buildInfoRow(
                  "Model",
                  paymentItem.rezervacija?.automobil?.model ?? "N/A",
                ),
                const SizedBox(height: 12),
                const Text(
                  "Paketi:",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                ...paketi.map((paketInfo) {
                  var paket = paketInfo.paket;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6.0, left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ${paket?.naziv ?? "Nepoznat paket"}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (paket?.opis != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              '${paket!.opis}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () => _submitPayment(
                              paymentItem.rezervacija!.id!,
                              paymentItem.cijena ?? 0,
                            ),
                    icon: _isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.payment, color: Colors.white),
                    label: const Text(
                      "Plati",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
