import 'dart:convert';

import 'package:eservisnaknjiga_mobile/models/packages.dart';
import 'package:eservisnaknjiga_mobile/providers/base_provider.dart';

class PackagesProvider extends BaseProvider<Packages> {
  PackagesProvider() : super("Paketi/Klijent");

  @override
  Packages fromJson(data) {
    // TODO: implement fromJson
    return Packages.fromJson(data);
  }

  Future<List<Packages>> recommend(int id) async {
    var baseUrl =
        const String.fromEnvironment('BASE_URL_MOBILE', defaultValue: "");
    var uri = Uri.parse("${baseUrl}Paketi/$id/recommend");
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return (data as List).map((e) => Packages.fromJson(e)).toList();
    } else {
      throw Exception("Greška prilikom dobijanja preporuka.");
    }
  }
}
