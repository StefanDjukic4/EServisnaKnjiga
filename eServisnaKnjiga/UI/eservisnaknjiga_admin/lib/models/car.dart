import 'package:eservisnaknjiga_admin/models/client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'car.g.dart';

@JsonSerializable()
class Car {
  int? id;
  String? marka;
  String? model;
  int? godinaProizvodnje;
  String? registracija;
  String? brojSasije;
  Client? klijent;

  Car(this.id, this.marka, this.model, this.godinaProizvodnje,
      this.registracija, this.brojSasije, this.klijent);

  factory Car.fromJson(Map<String, dynamic> json) => _$CarFromJson(json);

  Map<String, dynamic> toJson() => _$CarToJson(this);
}
