import 'dart:convert';

import 'package:eservisnaknjiga_mobile/models/rezervation.dart';
import 'package:eservisnaknjiga_mobile/providers/base_provider.dart';

class RezervationProvider extends BaseProvider<Rezervation> {
  RezervationProvider() : super("Rezervacije/Klijent");

  @override
  Rezervation fromJson(data) {
    // TODO: implement fromJson
    return Rezervation.fromJson(data);
  }

  Future<String> initialzPayment(
    int workOrderId,
    num amount,
  ) async {
    var baseUrl =
        const String.fromEnvironment('BASE_URL_MOBILE', defaultValue: "");
    var uri = Uri.parse("${baseUrl}Rezervacije/Klijent/initialzPayment");
    var headers = createHeaders();

    var jsonRequest = jsonEncode({
      'Cijena': amount.toInt(),
      'RadniNalogId': workOrderId,
    });

    var response = await http!.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = response.body;
      return data;
    } else {
      throw Exception("Greška prilikom inicijalizacije plaćanja.");
    }
  }

  Future<Rezervation> successfulPayment(
    int id,
  ) async {
    var baseUrl =
        const String.fromEnvironment('BASE_URL_MOBILE', defaultValue: "");
    var uri = Uri.parse("${baseUrl}Rezervacije/$id/Klijent/successfulPayment");
    var headers = createHeaders();

    var response = await http!.put(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Greška prilikom spasavanj uspjesnog plaćanja.");
    }
  }
}
