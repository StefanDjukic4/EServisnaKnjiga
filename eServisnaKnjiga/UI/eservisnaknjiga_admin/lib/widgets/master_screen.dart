import 'package:eservisnaknjiga_admin/main.dart';
import 'package:eservisnaknjiga_admin/screens/news_list_screen.dart';
import 'package:eservisnaknjiga_admin/screens/package_list_screen.dart';
import 'package:eservisnaknjiga_admin/screens/repairman_list_screen.dart';
import 'package:eservisnaknjiga_admin/screens/client_list_screen.dart';
import 'package:eservisnaknjiga_admin/screens/calendar_list_screen.dart';
import 'package:eservisnaknjiga_admin/screens/report_list_screen.dart';
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
              leading: const Icon(Icons.login_outlined),
              title: const Text("Login"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.workspaces_outline),
              title: const Text("Majstori"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RepairmanListScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined),
              title: const Text("Termini"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CalendarListScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("Korisnici"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ClientListScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_car_outlined),
              title: const Text("Automobili"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CarListScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.newspaper_outlined),
              title: const Text("Pocetna strana"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NewsListScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box_outlined),
              title: const Text("Paketi"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PackageListScreen()));
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.price_change_outlined),
            //   title: const Text("Radni nalog"),
            //   onTap: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => const CarListScreen()));
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.insert_chart_outlined_outlined),
              title: const Text("Izvjestaji"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ReportListScreen()));
              },
            )
          ],
        ),
      ),
      body: widget.child!,
    );
  }
}
