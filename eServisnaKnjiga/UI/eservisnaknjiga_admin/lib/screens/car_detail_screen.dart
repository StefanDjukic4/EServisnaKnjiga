import 'package:eservisnaknjiga_admin/models/car.dart';
import 'package:eservisnaknjiga_admin/models/client.dart';
import 'package:eservisnaknjiga_admin/models/news.dart';
import 'package:eservisnaknjiga_admin/models/search_result.dart';
import 'package:eservisnaknjiga_admin/providers/car_provider.dart';
import 'package:eservisnaknjiga_admin/providers/client_provider.dart';
import 'package:eservisnaknjiga_admin/providers/news_provider.dart';
import 'package:eservisnaknjiga_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class CarDetailScreen extends StatefulWidget {
  Car? car;
  CarDetailScreen({Key? key, this.car}) : super(key: key);

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late CarProvider _carProvider;
  late ClientProvider _clientProvider;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'model': widget.car?.model,
      'marka': widget.car?.marka,
      'godinaProizvodnje': widget.car?.godinaProizvodnje?.toString(),
      'registracija': widget.car?.registracija,
      'brojSasije': widget.car?.brojSasije,
      'klijentId': widget.car?.klijent?.ime?.toString()
    };

    _carProvider = context.read<CarProvider>();
    _clientProvider = context.read<ClientProvider>();
    initForm();
  }

  Future initForm() async {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Column(
        children: [
          isLoading ? Container() : _buildForm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () async {
                      _formKey.currentState?.saveAndValidate();
                      print(_formKey.currentState?.value);
                      try {
                        if (widget.car == null) {
                          await _carProvider
                              .insert(_formKey.currentState?.value);
                        } else {
                          await _carProvider.update(
                              widget.car!.id!, _formKey.currentState?.value);
                        }
                      } on Exception catch (e) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("OK"))
                                  ],
                                ));
                      }
                    },
                    child: Text("Sacuvati izmjenu")),
              ),
            ],
          )
        ],
      ),
      title: this.widget.car?.marka ?? "nema",
    );
  }

  FormBuilder _buildForm() {
    Future<SearchResult<Client>> clients = _clientProvider.get();
    print(clients);
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Marka:"),
                      name: "marka")),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Model:"),
                      name: "model")),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: FormBuilderTextField(
                      decoration:
                          InputDecoration(labelText: "Godina Proizvodnje:"),
                      name: "godinaProizvodnje")),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: FormBuilderTextField(
                      decoration:
                          InputDecoration(labelText: "Registarske oznake:"),
                      name: "registracija")),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Broj sasije:"),
                      name: "brojSasije"))
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Klijent:"),
                      name: "klijentId"))
            ],
          )
        ],
      ),
    );
  }
}
