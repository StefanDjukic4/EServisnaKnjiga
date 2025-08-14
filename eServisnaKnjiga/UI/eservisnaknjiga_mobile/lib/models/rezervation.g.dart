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
    );

Map<String, dynamic> _$RezervationToJson(Rezervation instance) =>
    <String, dynamic>{
      'automobilId': instance.automobilId,
      'datum': instance.datum?.toIso8601String(),
      'opis': instance.opis,
      'packageIdList': instance.packageIdList,
    };
