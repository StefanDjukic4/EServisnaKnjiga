import 'package:eservisnaknjiga_admin/models/repairman.dart';
import 'package:eservisnaknjiga_admin/models/reservation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'work_order.g.dart';

@JsonSerializable()
class WorkOrder {
  int? rezervacijaId;
  int? majstorId;
  DateTime? datum;
  String? opis;
  double? cijena;
  String? nacinPlacanja;
  Repairman? majstor;
  Reservation? rezervacija;

  WorkOrder(this.rezervacijaId, this.majstorId, this.datum, this.opis,
      this.cijena, this.nacinPlacanja, this.majstor, this.rezervacija);
  factory WorkOrder.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderFromJson(json);

  Map<String, dynamic> toJson() => _$WorkOrderToJson(this);
}
