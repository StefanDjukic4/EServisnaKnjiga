import 'package:eservisnaknjiga_admin/models/car.dart';
import 'package:eservisnaknjiga_admin/models/reservation_package.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation.g.dart';

@JsonSerializable()
class Reservation {
  int? id;
  int? automobilId;
  DateTime? datum;
  String? opis;
  String? status;
  Car? automobil;
  List<ReservationPackage>? rezervacijaPaketi;

  Reservation(this.id, this.automobilId, this.datum, this.opis, this.status,
      this.automobil, this.rezervacijaPaketi);

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}
