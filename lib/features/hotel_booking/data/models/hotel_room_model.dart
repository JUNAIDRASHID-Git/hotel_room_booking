import '../../domain/entities/hotel_room.dart';

class HotelRoomModel extends HotelRoom {
  const HotelRoomModel({
    required super.code,
    required super.type,
    required super.pricePerNight,
    required super.maxGuests,
    required super.description,
    required super.amenities,
    super.bookedRanges,
  });

  factory HotelRoomModel.fromJson(Map<String, dynamic> json) {
    List<BookingDateRange> parsedRanges = [];
    if (json['bookedRanges'] != null) {
      for (var r in json['bookedRanges'] as List<dynamic>) {
        parsedRanges.add(
          BookingDateRange(
            checkIn: DateTime.parse(r['checkIn'] as String),
            checkOut: DateTime.parse(r['checkOut'] as String),
          ),
        );
      }
    }

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
      bookedRanges: parsedRanges,
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
      'bookedRanges': bookedRanges
          .map((r) => {
                'checkIn': r.checkIn.toIso8601String(),
                'checkOut': r.checkOut.toIso8601String(),
              })
          .toList(),
    };
  }
}
