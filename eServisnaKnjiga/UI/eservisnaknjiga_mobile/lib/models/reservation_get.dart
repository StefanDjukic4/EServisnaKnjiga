import 'package:eservisnaknjiga_mobile/models/car.dart';
import 'package:eservisnaknjiga_mobile/models/reservation_package.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation_get.g.dart';

@JsonSerializable()
class ReservationGet {
  int? id;
  int? automobilId;
  DateTime? datum;
  String? opis;
  String? status;
  Car? automobil;
  List<ReservationPackage>? rezervacijaPaketi;

  ReservationGet(this.id, this.automobilId, this.datum, this.opis, this.status,
      this.automobil, this.rezervacijaPaketi);

  factory ReservationGet.fromJson(Map<String, dynamic> json) =>
      _$ReservationGetFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationGetToJson(this);
}
