// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationPackage _$ReservationPackageFromJson(Map<String, dynamic> json) =>
    ReservationPackage(
      (json['id'] as num?)?.toInt(),
      (json['rezervacijaId'] as num?)?.toInt(),
      (json['paketId'] as num?)?.toInt(),
      json['paket'] == null
          ? null
          : Package.fromJson(json['paket'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReservationPackageToJson(ReservationPackage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rezervacijaId': instance.rezervacijaId,
      'paketId': instance.paketId,
      'paket': instance.paket,
    };
