import 'package:json_annotation/json_annotation.dart';

part 'client.g.dart';

@JsonSerializable()
class Client {
  int? id;
  String? ime;
  String? prezime;
  String? telefon;
  String? email;
  String? adresa;

  Client(
      this.id, this.ime, this.prezime, this.telefon, this.email, this.adresa);

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  Map<String, dynamic> toJson() => _$ClientToJson(this);
}
