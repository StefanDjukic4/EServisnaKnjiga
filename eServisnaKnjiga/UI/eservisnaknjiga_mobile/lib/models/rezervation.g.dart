// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rezervation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rezervation _$RezervationFromJson(Map<String, dynamic> json) => Rezervation(
      (json['automobilId'] as num?)?.toInt(),
      json['datum'] == null ? null : DateTime.parse(json['datum'] as String),
      json['opis'] as String?,
      (json['packageIdList'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      json['automobil'] == null
          ? null
          : Car.fromJson(json['automobil'] as Map<String, dynamic>),
      (json['id'] as num?)?.toInt(),
      json['status'] as String?,
    );

Map<String, dynamic> _$RezervationToJson(Rezervation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'automobilId': instance.automobilId,
      'automobil': instance.automobil,
      'datum': instance.datum?.toIso8601String(),
      'opis': instance.opis,
      'packageIdList': instance.packageIdList,
    };
