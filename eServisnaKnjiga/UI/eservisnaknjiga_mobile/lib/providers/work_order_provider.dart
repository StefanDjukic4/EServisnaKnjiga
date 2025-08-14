import 'package:eservisnaknjiga_mobile/models/work_order.dart';
import 'package:eservisnaknjiga_mobile/providers/base_provider.dart';

class WorkOrderProvider extends BaseProvider<WorkOrder> {
  WorkOrderProvider() : super("RadniNalog/Klijent/Payment");

  @override
  WorkOrder fromJson(data) {
    // TODO: implement fromJson
    return WorkOrder.fromJson(data);
  }
}
