import 'package:eservisnaknjiga_admin/models/work_order.dart';
import 'package:eservisnaknjiga_admin/providers/base_provider.dart';

class WorkOrderProvider extends BaseProvider<WorkOrder> {
  WorkOrderProvider() : super("RadniNalog");

  @override
  WorkOrder fromJson(data) {
    // TODO: implement fromJson
    return WorkOrder.fromJson(data);
  }
}
