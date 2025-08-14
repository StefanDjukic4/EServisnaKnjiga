import 'package:json_annotation/json_annotation.dart';

part 'repairman.g.dart';

@JsonSerializable()
class Repairman {
  int? id;
  String? ime;
  String? prezime;
  String? datumRodjenja;

  Repairman(this.id, this.ime, this.prezime, this.datumRodjenja);

  factory Repairman.fromJson(Map<String, dynamic> json) =>
      _$RepairmanFromJson(json);

  Map<String, dynamic> toJson() => _$RepairmanToJson(this);
}
