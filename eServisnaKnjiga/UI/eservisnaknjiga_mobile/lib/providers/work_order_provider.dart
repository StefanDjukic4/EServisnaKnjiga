import 'dart:convert';

import 'package:eservisnaknjiga_mobile/models/search_result.dart';
import 'package:eservisnaknjiga_mobile/models/work_order.dart';
import 'package:eservisnaknjiga_mobile/providers/base_provider.dart';

class WorkOrderProvider extends BaseProvider<WorkOrder> {
  WorkOrderProvider() : super("RadniNalog/Klijent/Payment");

  @override
  WorkOrder fromJson(data) {
    // TODO: implement fromJson
    return WorkOrder.fromJson(data);
  }

  Future<SearchResult<WorkOrder>> getCarServiceList(
    int id,
  ) async {
    var baseUrl =
        const String.fromEnvironment('BASE_URL_MOBILE', defaultValue: "");
    var uri = Uri.parse("${baseUrl}RadniNalog/Klijent/CarServiceList/$id");
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<WorkOrder>();

      result.count = data['count'];

      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw Exception("Greška prilikom učitavanja rezervacija klijenta.");
    }
  }
}
