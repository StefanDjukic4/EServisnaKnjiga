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

  Future<List<Rezervation>> getReservationListForClient(
    int id,
  ) async {
    var baseUrl =
        const String.fromEnvironment('BASE_URL_MOBILE', defaultValue: "");
    var uri = Uri.parse("${baseUrl}Rezervacije/Klijent?id=$id");
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body) as List;
      return data.map((json) => Rezervation.fromJson(json)).toList();
    } else {
      throw Exception("Greška prilikom učitavanja rezervacija klijenta.");
    }
  }

  Future<Rezervation> setState(int id, String state, [dynamic request]) async {
    var baseUrl =
        const String.fromEnvironment('BASE_URL_MOBILE', defaultValue: "");

    var url = "${baseUrl}Rezervacije/$id/client$state";
    var uri = Uri.parse(url);
    var headres = createHeaders();

    var jsonRequest = jsonEncode(request);

    var response = await http!.put(uri, headers: headres, body: jsonRequest);

    if (isValidResponse(response)) {
      print("response: ${response.statusCode}, ${response.body}");
      var data = jsonDecode(response.body);

      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }
}
