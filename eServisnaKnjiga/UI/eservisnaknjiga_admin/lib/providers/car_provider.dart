import 'package:eservisnaknjiga_admin/models/car.dart';
import 'package:eservisnaknjiga_admin/providers/base_provider.dart';

class CarProvider extends BaseProvider<Car> {
  CarProvider() : super("Automobil");

  @override
  Car fromJson(data) {
    // TODO: implement fromJson
    return Car.fromJson(data);
  }
}
