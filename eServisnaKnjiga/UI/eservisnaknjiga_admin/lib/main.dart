import 'package:eservisnaknjiga_admin/providers/calendar_provider.dart';
import 'package:eservisnaknjiga_admin/providers/car_provider.dart';
import 'package:eservisnaknjiga_admin/providers/news_provider.dart';
import 'package:eservisnaknjiga_admin/providers/client_provider.dart';
import 'package:eservisnaknjiga_admin/providers/package_provider.dart';
import 'package:eservisnaknjiga_admin/providers/repairman_provider.dart';
import 'package:eservisnaknjiga_admin/providers/reservation_provider.dart';
import 'package:eservisnaknjiga_admin/providers/work_order_provider.dart';
import 'package:eservisnaknjiga_admin/screens/car_list_screen.dart';
import 'package:eservisnaknjiga_admin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await windowManager.ensureInitialized();
  //await dotenv.load(fileName: ".env");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CarProvider()),
      ChangeNotifierProvider(create: (_) => RepairmanProvider()),
      ChangeNotifierProvider(create: (_) => NewsProvider()),
      ChangeNotifierProvider(create: (_) => PackageProvider()),
      ChangeNotifierProvider(create: (_) => ClientProvider()),
      ChangeNotifierProvider(create: (_) => ReservationProvider()),
      ChangeNotifierProvider(create: (_) => CalendarProvider()),
      ChangeNotifierProvider(create: (_) => WorkOrderProvider())
    ],
    child: const MyMaterialApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MyMaterialApp();
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "eServisnaKnjiga",
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late CarProvider _carProvider;

  @override
  Widget build(BuildContext context) {
    _carProvider = context.read<CarProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "E-mail",
                      prefixIcon: Icon(Icons.mail),
                      border: OutlineInputBorder(),
                    ),
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        var username = _usernameController.text;
                        var password = _passwordController.text;

                        Authorization.username = username;
                        Authorization.password = password;

                        try {
                          await _carProvider.get();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const CarListScreen()),
                          );
                        } on Exception catch (e) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("Error"),
                              content: Text(e.toString()),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: const Text("LOGIN"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
