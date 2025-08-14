import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import 'package:eservisnaknjiga_admin/models/repairman.dart';
import 'package:eservisnaknjiga_admin/models/reservation.dart';
import 'package:eservisnaknjiga_admin/models/work_order.dart';
import 'package:eservisnaknjiga_admin/providers/repairman_provider.dart';
import 'package:eservisnaknjiga_admin/providers/reservation_provider.dart';
import 'package:eservisnaknjiga_admin/providers/work_order_provider.dart';

class WorkOrderScreen extends StatefulWidget {
  final int id;

  const WorkOrderScreen({super.key, required this.id});

  @override
  _WorkOrderScreenState createState() => _WorkOrderScreenState();
}

class _WorkOrderScreenState extends State<WorkOrderScreen> {
  late ReservationProvider _reservationProvider;
  late RepairmanProvider _repairmanProvider;
  late WorkOrderProvider _workOrderProvider;

  Reservation? reservationResult;
  List<Repairman>? repairmanList;
  final Map<int, TextEditingController> _priceControllers = {};
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double totalPrice = 0.0;
  int? selectedRepairmanId;
  String? selectedPaymentMethod; // Dodano: Način plaćanja

  @override
  void initState() {
    super.initState();
    _reservationProvider = context.read<ReservationProvider>();
    _repairmanProvider = context.read<RepairmanProvider>();
    _workOrderProvider = context.read<WorkOrderProvider>();
    fetchOrderData();
  }

  void fetchOrderData() async {
    var reservationData = await _reservationProvider.getById(widget.id);
    var repairmanData = await _repairmanProvider.get();

    setState(() {
      reservationResult = reservationData;
      for (var pkg in reservationResult!.rezervacijaPaketi!) {
        _priceControllers[pkg.paket!.id!] = TextEditingController();
      }
      repairmanList = repairmanData.result;
    });
  }

  void updateTotalPrice() {
    double newTotalPrice = 0.0;
    _priceControllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        newTotalPrice += double.tryParse(controller.text) ?? 0.0;
      }
    });
    setState(() {
      totalPrice = newTotalPrice;
    });
  }

  String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cijena je obavezna.';
    }
    if (double.tryParse(value) == null) {
      return 'Unesite važeću cijenu.';
    }
    return null;
  }

  void _saveWorkOrder() async {
    if (_formKey.currentState!.validate()) {
      final workOrder = WorkOrder(
          reservationResult!.id,
          selectedRepairmanId,
          DateTime.now(),
          _descriptionController.text.trim(),
          totalPrice,
          selectedPaymentMethod,
          null,
          null);

      try {
        await _workOrderProvider.insert(workOrder);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Radni nalog uspješno spašen.')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Greška pri spremanju: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kreiranje radnog naloga")),
      body: reservationResult == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: [
                              infoBox(
                                "Podaci o klijentu",
                                "Ime: ${reservationResult!.automobil!.klijent!.ime} ${reservationResult!.automobil!.klijent!.prezime}\n"
                                    "Telefon: ${reservationResult!.automobil!.klijent!.telefon}\n"
                                    "Email: ${reservationResult!.automobil!.klijent!.email}\n"
                                    "Adresa: ${reservationResult!.automobil!.klijent!.adresa}",
                              ),
                              infoBox(
                                "Podaci o automobilu",
                                "Marka: ${reservationResult!.automobil!.marka}\n"
                                    "Model: ${reservationResult!.automobil!.model}\n"
                                    "Godina: ${reservationResult!.automobil!.godinaProizvodnje}\n"
                                    "Registracija: ${reservationResult!.automobil!.registracija}",
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          const Text("Lista paketa",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 160,
                                  dataRowMinHeight: 60,
                                  dataRowMaxHeight: 70,
                                  headingRowHeight: 40,
                                  columns: const [
                                    DataColumn(label: Text("Paket")),
                                    DataColumn(
                                        label: Text("Preporučena cijena")),
                                    DataColumn(label: Text("Stvarna cijena")),
                                  ],
                                  rows: reservationResult!.rezervacijaPaketi!
                                      .map<DataRow>((pkg) {
                                    return DataRow(cells: [
                                      DataCell(Text(pkg.paket!.naziv!)),
                                      DataCell(Text(
                                          "${pkg.paket!.minimalnaCijena} - ${pkg.paket!.maksimalnaCijena}")),
                                      DataCell(
                                        SizedBox(
                                          width: 120,
                                          height: 40,
                                          child: TextFormField(
                                            controller: _priceControllers[
                                                pkg.paket!.id!],
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "Cijena",
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9.]'))
                                            ],
                                            onChanged: (value) {
                                              updateTotalPrice();
                                            },
                                            validator: validatePrice,
                                          ),
                                        ),
                                      ),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                              "Ukupna cijena: ${totalPrice.toStringAsFixed(2)} KM",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 30),
                          const Text("Odaberite majstora",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<int>(
                            value: selectedRepairmanId,
                            hint: const Text("Izaberite majstora"),
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedRepairmanId = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Odabir majstora je obavezan.';
                              }
                              return null;
                            },
                            items: repairmanList!.map((r) {
                              return DropdownMenuItem<int>(
                                value: r.id!,
                                child: Text("${r.ime} ${r.prezime}"),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 30),
                          const Text("Opis radnog naloga",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Unesite opis radnog naloga",
                              alignLabelWithHint: true,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Opis ne može biti prazan.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),

                          // Novi dio: Dropdown za način plaćanja
                          const Text("Način plaćanja",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedPaymentMethod,
                            hint: const Text("Odaberite način plaćanja"),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedPaymentMethod = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Način plaćanja je obavezan.';
                              }
                              return null;
                            },
                            items: const [
                              DropdownMenuItem(
                                value: 'Kes',
                                child: Text('Keš'),
                              ),
                              DropdownMenuItem(
                                value: 'M_placanje',
                                child: Text('M Plaćanje'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              actionButton(
                                  "Spasi", Colors.green, _saveWorkOrder),
                              const SizedBox(width: 10),
                              actionButton(
                                  "Printanje", Colors.orange, _printWorkOrder),
                            ],
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

  Widget infoBox(String title, String content) {
    return Container(
      width: 360,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blueGrey, width: 1.5),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(content,
              textAlign: TextAlign.left, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget actionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child:
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
    );
  }

  void _printWorkOrder() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Molimo popunite sva obavezna polja prije printanja.")),
      );
      return;
    }

    final pdf = pw.Document();

    final baseFont = await PdfGoogleFonts.openSansRegular();
    final boldFont = await PdfGoogleFonts.openSansBold();

    final selectedRepairman =
        repairmanList!.firstWhere((r) => r.id == selectedRepairmanId);

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: baseFont,
          bold: boldFont,
        ),
        build: (pw.Context context) => [
          pw.Text("Radni nalog",
              style:
                  pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          pw.Text("Klijent: ${reservationResult!.automobil!.klijent!.ime} "
              "${reservationResult!.automobil!.klijent!.prezime}"),
          pw.Text("Telefon: ${reservationResult!.automobil!.klijent!.telefon}"),
          pw.Text("Email: ${reservationResult!.automobil!.klijent!.email}"),
          pw.Text("Adresa: ${reservationResult!.automobil!.klijent!.adresa}"),
          pw.SizedBox(height: 10),
          pw.Text("Automobil: ${reservationResult!.automobil!.marka} "
              "${reservationResult!.automobil!.model}"),
          pw.Text("Godina: ${reservationResult!.automobil!.godinaProizvodnje}"),
          pw.Text(
              "Registracija: ${reservationResult!.automobil!.registracija}"),
          pw.SizedBox(height: 20),
          pw.Text("Paketi i cijene:",
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headers: ['Paket', 'Stvarna cijena (KM)'],
            data: reservationResult!.rezervacijaPaketi!.map((pkg) {
              final controller = _priceControllers[pkg.paket!.id!];
              final enteredPrice =
                  double.tryParse(controller?.text ?? '0') ?? 0.0;
              final formattedPrice = enteredPrice.toStringAsFixed(2);
              return [
                pkg.paket!.naziv ?? '',
                "$formattedPrice KM",
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Text("Ukupna cijena: ${totalPrice.toStringAsFixed(2)} KM",
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          pw.Text(
              "Majstor: ${selectedRepairman.ime} ${selectedRepairman.prezime}"),
          pw.SizedBox(height: 10),
          pw.Text("Opis radnog naloga:",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(_descriptionController.text),
          pw.SizedBox(height: 10),
          if (selectedPaymentMethod != null)
            pw.Text("Način plaćanja: $selectedPaymentMethod"),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}
