import 'package:eservisnaknjiga_admin/models/package.dart';
import 'package:eservisnaknjiga_admin/providers/base_provider.dart';

class PackageProvider extends BaseProvider<Package> {
  PackageProvider() : super("Paketi");

  @override
  Package fromJson(data) {
    // TODO: implement fromJson
    return Package.fromJson(data);
  }
}
