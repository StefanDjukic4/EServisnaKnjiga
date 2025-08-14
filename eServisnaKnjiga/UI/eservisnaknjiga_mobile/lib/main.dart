import 'package:eservisnaknjiga_mobile/providers/car_provider.dart';
import 'package:eservisnaknjiga_mobile/providers/news_provider.dart';
import 'package:eservisnaknjiga_mobile/providers/packages_provider.dart';
import 'package:eservisnaknjiga_mobile/providers/rezervation_provider.dart';
import 'package:eservisnaknjiga_mobile/providers/work_order_provider.dart';
import 'package:eservisnaknjiga_mobile/screens/news_list_screen.dart';
import 'package:eservisnaknjiga_mobile/utils/util.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  stripe.Stripe.publishableKey =
      "pk_test_51Ms4eeA0iQOCJUgu9h1EF8l7nqbrnxXHRaAN6hAcXcABassvJBdqxyQuPCWFqntcthwsPxCEQ2kvOzez60At6VWG00D4C3MgXP";
  await stripe.Stripe.instance.applySettings();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => PackagesProvider()),
        ChangeNotifierProvider(create: (_) => WorkOrderProvider()),
        ChangeNotifierProvider(create: (_) => RezervationProvider()),
      ],
      child: const MyMaterialApp(),
    ),
  );
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

  late NewsProvider _newsProvider;

  @override
  Widget build(BuildContext context) {
    _newsProvider = context.read<NewsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors
            .transparent, // Transparent app bar for better background effect
      ),
      body: SizedBox.expand(
        // This will make the Container fill the entire screen
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 800),
                            child: Image.asset(
                              "assets/images/sample_0.jpg",
                              width: 120,
                              height: 120,
                            ),
                          ),
                          const SizedBox(height: 24),
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 800),
                            child: TextField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: "E-mail",
                                prefixIcon: Icon(Icons.mail),
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.0),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 800),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 800),
                            child: ElevatedButton(
                              onPressed: () async {
                                var username = _usernameController.text;
                                var password = _passwordController.text;
                                print("LOGIN: $username $password");

                                Authorization.username = username;
                                Authorization.password = password;

                                try {
                                  await _newsProvider.get();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const NewsListScreen()));
                                } catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text("Error"),
                                      content: Text(e.toString()),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("OK")),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: const Text("Login"),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blueAccent,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 5,
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
          ),
        ),
      ),
    );
  }
}
