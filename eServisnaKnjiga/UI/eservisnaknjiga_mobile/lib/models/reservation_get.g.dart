// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_get.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationGet _$ReservationGetFromJson(Map<String, dynamic> json) =>
    ReservationGet(
      (json['id'] as num?)?.toInt(),
      (json['automobilId'] as num?)?.toInt(),
      json['datum'] == null ? null : DateTime.parse(json['datum'] as String),
      json['opis'] as String?,
      json['status'] as String?,
      json['automobil'] == null
          ? null
          : Car.fromJson(json['automobil'] as Map<String, dynamic>),
      (json['rezervacijaPaketi'] as List<dynamic>?)
          ?.map((e) => ReservationPackage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReservationGetToJson(ReservationGet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'automobilId': instance.automobilId,
      'datum': instance.datum?.toIso8601String(),
      'opis': instance.opis,
      'status': instance.status,
      'automobil': instance.automobil,
      'rezervacijaPaketi': instance.rezervacijaPaketi,
    };
