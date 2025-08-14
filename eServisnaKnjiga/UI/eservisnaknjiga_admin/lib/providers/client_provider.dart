import 'package:eservisnaknjiga_admin/models/client.dart';
import 'package:eservisnaknjiga_admin/providers/base_provider.dart';

class ClientProvider extends BaseProvider<Client> {
  ClientProvider() : super("Klijenti");

  @override
  Client fromJson(data) {
    // TODO: implement fromJson
    return Client.fromJson(data);
  }
}
