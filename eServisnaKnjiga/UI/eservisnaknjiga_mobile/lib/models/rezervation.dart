import 'package:eservisnaknjiga_mobile/models/car.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rezervation.g.dart';

@JsonSerializable()
class Rezervation {
  int? id;
  String? status;
  int? automobilId;
  Car? automobil;
  DateTime? datum;
  String? opis;
  List<int>? packageIdList;

  Rezervation(this.automobilId, this.datum, this.opis, this.packageIdList,
      this.automobil, this.id, this.status);

  factory Rezervation.fromJson(Map<String, dynamic> json) =>
      _$RezervationFromJson(json);

  Map<String, dynamic> toJson() => _$RezervationToJson(this);
}
