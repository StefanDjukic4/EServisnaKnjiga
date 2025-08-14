import 'package:eservisnaknjiga_mobile/models/packages.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation_package.g.dart';

@JsonSerializable()
class ReservationPackage {
  int? id;
  int? rezervacijaId;
  int? paketId;
  Packages? paket;

  ReservationPackage(this.id, this.rezervacijaId, this.paketId, this.paket);

  factory ReservationPackage.fromJson(Map<String, dynamic> json) =>
      _$ReservationPackageFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationPackageToJson(this);
}
