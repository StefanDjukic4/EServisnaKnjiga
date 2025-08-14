import 'package:eservisnaknjiga_mobile/main.dart';
import 'package:eservisnaknjiga_mobile/screens/news_list_screen.dart';
import 'package:eservisnaknjiga_mobile/screens/packages_list_screen.dart';
import 'package:eservisnaknjiga_mobile/screens/payment_list_screen%20copy.dart';
import 'package:eservisnaknjiga_mobile/screens/reservation_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../screens/car_list_screen.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  MasterScreenWidget({this.child, this.title, super.key});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text("Log out"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text("Pocetna stranica"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NewsListScreen(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_calendar_outlined),
              title: const Text("Rezervacija"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ReservationListScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.library_add_check_outlined),
              title: const Text("Ponuda paketa"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PackagesListScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment_outlined),
              title: const Text("Placanje"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PaymentListScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.car_repair_outlined),
              title: const Text("Automobili"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CarListScreen()));
              },
            ),
          ],
        ),
      ),
      body: widget.child!,
    );
  }
}
