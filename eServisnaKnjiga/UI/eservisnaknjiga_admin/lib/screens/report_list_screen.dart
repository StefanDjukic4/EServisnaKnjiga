import 'dart:typed_data';
import 'package:eservisnaknjiga_admin/models/work_order.dart';
import 'package:eservisnaknjiga_admin/providers/car_provider.dart';
import 'package:eservisnaknjiga_admin/providers/repairman_provider.dart';
import 'package:eservisnaknjiga_admin/providers/work_order_provider.dart';
import 'package:eservisnaknjiga_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  String? selectedMajstor;
  String? selectedAuto;
  DateTime? datumOd;
  DateTime? datumDo;

  final DateFormat dateFormat = DateFormat('dd.MM.yyyy.');

  late RepairmanProvider _repairmanProvider;
  late CarProvider _carProvider;
  late WorkOrderProvider _workOrderProvider;

  List<dynamic> majstori = [];
  List<dynamic> automobili = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repairmanProvider = context.read<RepairmanProvider>();
    _carProvider = context.read<CarProvider>();
    _workOrderProvider = context.read<WorkOrderProvider>();
    _fetchDropdownData();
  }

  Future<void> _fetchDropdownData() async {
    var majstoriResult = await _repairmanProvider.get();
    var autiResult = await _carProvider.get();
    setState(() {
      majstori = majstoriResult.result;
      automobili = autiResult.result;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime danas = DateTime.now();
    final DateTime danasMinus2 = danas.subtract(const Duration(days: 2));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFrom
          ? (datumOd ?? danasMinus2)
          : (datumDo ?? datumOd ?? danasMinus2),
      firstDate: isFrom ? DateTime(2000) : (datumOd ?? DateTime(2000)),
      lastDate: danas,
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          if (picked.isAfter(danasMinus2)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Datum od mora biti najmanje 2 dana pre današnjeg datuma')),
            );
            return;
          }
          datumOd = picked;
          if (datumDo != null && datumDo!.isBefore(datumOd!)) {
            datumDo = null;
          }
        } else {
          if (datumOd != null && picked.isBefore(datumOd!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Datum do ne može biti manji od datuma od')),
            );
            return;
          }
          datumDo = picked;
        }
      });
    }
  }

  bool _isValidSelection() {
    bool hasMajstorOrAuto =
        (selectedMajstor != null && selectedMajstor!.isNotEmpty) ||
            (selectedAuto != null && selectedAuto!.isNotEmpty);
    bool hasBothDates = datumOd != null && datumDo != null;
    return hasMajstorOrAuto && hasBothDates;
  }

  Future<void> _onCreatePdf() async {
    if (!_isValidSelection()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Molimo odaberite majstora ili automobil i oba datuma')),
      );
      return;
    }

    final Map<String, dynamic> filter = {
      if (selectedMajstor != null) 'majstorId': selectedMajstor,
      if (selectedAuto != null) 'automobilId': selectedAuto,
      'datumOd': DateFormat('yyyy-MM-dd').format(datumOd!),
      'datumDo': DateFormat('yyyy-MM-dd').format(datumDo!),
    };

    var response = await _workOrderProvider.get(filter: filter);
    List<WorkOrder> orders = response.result;

    if (orders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nema podataka za generisanje PDF-a')),
      );
      return;
    }

    final pdfFile = await _buildPdf(orders);
    await Printing.layoutPdf(onLayout: (format) async => pdfFile);
  }

  Future<Uint8List> _buildPdf(List<WorkOrder> orders) async {
    final pdf = pw.Document();

    final baseFont = await PdfGoogleFonts.openSansRegular();
    final boldFont = await PdfGoogleFonts.openSansBold();

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: baseFont,
          bold: boldFont,
        ),
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return [
            pw.Center(
              child: pw.Text(
                'Izvještaj o radovima',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 16),
            ...orders.map((e) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 16),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(8),
                  color: PdfColors.grey100,
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Datum: ${dateFormat.format(e.datum!)}',
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          'Cijena: ${e.cijena} KM',
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      'Opis: ${e.opis}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.Divider(
                        height: 14, thickness: 1, color: PdfColors.grey400),
                    pw.Text(
                      'Majstor: ${e.majstor?.ime ?? ''} ${e.majstor?.prezime ?? ''}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      'Automobil: ${e.rezervacija?.automobil?.marka ?? ''} ${e.rezervacija?.automobil?.model ?? ''}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      'Broj sasije: ${e.rezervacija?.automobil?.brojSasije ?? ''}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      'Klijent: ${e.rezervacija?.automobil?.klijent?.ime ?? ''} ${e.rezervacija?.automobil?.klijent?.prezime ?? ''}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    if (e.rezervacija?.rezervacijaPaketi != null &&
                        e.rezervacija!.rezervacijaPaketi!.isNotEmpty) ...[
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Paketi:',
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: e.rezervacija!.rezervacijaPaketi!.map((p) {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 4),
                            child: pw.Text(
                              '- ${p.paket?.naziv ?? ''}: ${p.paket?.opis ?? ''}',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ];
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Izvještaj o radovima",
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Majstor'),
                    value: selectedMajstor,
                    items: majstori
                        .map((m) => DropdownMenuItem<String>(
                              value: m.id.toString(),
                              child: Text('${m.ime} ${m.prezime}'),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedMajstor = value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Auto'),
                    value: selectedAuto,
                    items: automobili
                        .map((a) => DropdownMenuItem<String>(
                              value: a.id.toString(),
                              child:
                                  Text('${a.marka} ${a.model} ${a.brojSasije}'),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => selectedAuto = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Datum od',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _selectDate(context, true),
                    controller: TextEditingController(
                      text: datumOd != null ? dateFormat.format(datumOd!) : '',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Datum do',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _selectDate(context, false),
                    controller: TextEditingController(
                      text: datumDo != null ? dateFormat.format(datumDo!) : '',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _isValidSelection() ? _onCreatePdf : null,
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: const Text('Kreiraj PDF izvještaj'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
