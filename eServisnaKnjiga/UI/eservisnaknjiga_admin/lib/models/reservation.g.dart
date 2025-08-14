// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
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

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'automobilId': instance.automobilId,
      'datum': instance.datum?.toIso8601String(),
      'opis': instance.opis,
      'status': instance.status,
      'automobil': instance.automobil,
      'rezervacijaPaketi': instance.rezervacijaPaketi,
    };
