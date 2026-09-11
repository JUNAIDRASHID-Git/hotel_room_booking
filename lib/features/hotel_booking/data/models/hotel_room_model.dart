import '../../domain/entities/hotel_room.dart';

class HotelRoomModel extends HotelRoom {
  const HotelRoomModel({
    required super.code,
    required super.type,
    required super.pricePerNight,
    required super.maxGuests,
    required super.description,
    required super.amenities,
  });

  factory HotelRoomModel.fromJson(Map<String, dynamic> json) {
    return HotelRoomModel(
      code: json['code'] as String,
      type: json['type'] as String,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      maxGuests: json['maxGuests'] as int,
      description: json['description'] as String? ?? '',
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'type': type,
      'pricePerNight': pricePerNight,
      'maxGuests': maxGuests,
      'description': description,
      'amenities': amenities,
    };
  }
}
