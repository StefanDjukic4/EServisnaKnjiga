import 'package:eservisnaknjiga_admin/models/repairman.dart';
import 'package:eservisnaknjiga_admin/providers/base_provider.dart';

class RepairmanProvider extends BaseProvider<Repairman> {
  RepairmanProvider() : super("Majstori");

  @override
  Repairman fromJson(data) {
    // TODO: implement fromJson
    return Repairman.fromJson(data);
  }
}
