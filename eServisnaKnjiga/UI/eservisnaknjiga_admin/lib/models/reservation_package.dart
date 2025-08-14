import 'package:json_annotation/json_annotation.dart';
import 'package:eservisnaknjiga_admin/models/package.dart';

part 'reservation_package.g.dart';

@JsonSerializable()
class ReservationPackage {
  int? id;
  int? rezervacijaId;
  int? paketId;
  Package? paket;

  ReservationPackage(this.id, this.rezervacijaId, this.paketId, this.paket);

  factory ReservationPackage.fromJson(Map<String, dynamic> json) =>
      _$ReservationPackageFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationPackageToJson(this);
}
