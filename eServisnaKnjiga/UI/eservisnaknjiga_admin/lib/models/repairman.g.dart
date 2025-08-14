// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repairman.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Repairman _$RepairmanFromJson(Map<String, dynamic> json) => Repairman(
      (json['id'] as num?)?.toInt(),
      json['ime'] as String?,
      json['prezime'] as String?,
      json['datumRodjenja'] as String?,
    );

Map<String, dynamic> _$RepairmanToJson(Repairman instance) => <String, dynamic>{
      'id': instance.id,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'datumRodjenja': instance.datumRodjenja,
    };
