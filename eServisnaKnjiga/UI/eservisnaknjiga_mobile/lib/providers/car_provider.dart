import 'package:eservisnaknjiga_mobile/models/car.dart';
import 'package:eservisnaknjiga_mobile/providers/base_provider.dart';

class CarProvider extends BaseProvider<Car> {
  CarProvider() : super("Automobil/Klijent");

  @override
  Car fromJson(data) {
    // TODO: implement fromJson
    return Car.fromJson(data);
  }
}
