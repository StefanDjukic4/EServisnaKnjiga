import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:eservisnaknjiga_admin/models/reservation.dart';
import 'package:eservisnaknjiga_admin/providers/base_provider.dart';

class ReservationProvider extends BaseProvider<Reservation> {
  ReservationProvider() : super("Rezervacije");

  @override
  Reservation fromJson(data) {
    // TODO: implement fromJson
    return Reservation.fromJson(data);
  }

  Future<Reservation> setState(int id, String state, [dynamic request]) async {
    var baseUrl =
        const String.fromEnvironment('BASE_URL_DESKTOP', defaultValue: "");

    var url = "${baseUrl}Rezervacije/$id/$state";
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

  Future<List<String>> getAllowedActions(int id, [dynamic request]) async {
    var baseUrl =
        const String.fromEnvironment('BASE_URL_DESKTOP', defaultValue: "");

    var url = "${baseUrl}Rezervacije/$id/allowedActions";
    var uri = Uri.parse(url);
    var headres = createHeaders();

    var response = await http!.get(uri, headers: headres);

    if (isValidResponse(response)) {
      print("response: ${response.statusCode}, ${response.body}");
      var data = jsonDecode(response.body);

      List<String> actions = List<String>.from(data);
      actions.sort();
      return actions;
    } else {
      throw new Exception("Unknown error");
    }
  }
}
