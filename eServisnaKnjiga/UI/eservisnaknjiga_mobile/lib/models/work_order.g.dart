// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkOrder _$WorkOrderFromJson(Map<String, dynamic> json) => WorkOrder(
      (json['rezervacijaId'] as num?)?.toInt(),
      (json['majstorId'] as num?)?.toInt(),
      json['datum'] == null ? null : DateTime.parse(json['datum'] as String),
      json['opis'] as String?,
      (json['cijena'] as num?)?.toDouble(),
      json['nacinPlacanja'] as String?,
      json['majstor'] == null
          ? null
          : Repairman.fromJson(json['majstor'] as Map<String, dynamic>),
      json['rezervacija'] == null
          ? null
          : ReservationGet.fromJson(
              json['rezervacija'] as Map<String, dynamic>),
      json['stripeClientSecret'] as String?,
    );

Map<String, dynamic> _$WorkOrderToJson(WorkOrder instance) => <String, dynamic>{
      'rezervacijaId': instance.rezervacijaId,
      'majstorId': instance.majstorId,
      'datum': instance.datum?.toIso8601String(),
      'opis': instance.opis,
      'cijena': instance.cijena,
      'nacinPlacanja': instance.nacinPlacanja,
      'majstor': instance.majstor,
      'rezervacija': instance.rezervacija,
      'stripeClientSecret': instance.stripeClientSecret,
    };
