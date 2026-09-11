import '../models/hotel_room_model.dart';

abstract class HotelLocalDataSource {
  Future<List<HotelRoomModel>> getRooms();
}

class HotelLocalDataSourceImpl implements HotelLocalDataSource {
  static List<Map<String, dynamic>> _getSampleData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return [
      {
        'code': 'R101',
        'type': 'Deluxe Room',
        'pricePerNight': 3500.0,
        'maxGuests': 2,
        'description': 'Modern, cozy sanctuary featuring a plush Queen bed, marble bathroom, and panoramic city views.',
        'amenities': ['Free Wi-Fi', 'AC', 'TV', 'Mini Bar'],
        'bookedRanges': [
          // R101 is booked for next week (+7 days to +10 days)
          {
            'checkIn': today.add(const Duration(days: 7)).toIso8601String(),
            'checkOut': today.add(const Duration(days: 10)).toIso8601String(),
          },
        ],
      },
      {
        'code': 'R102',
        'type': 'Deluxe Room',
        'pricePerNight': 3500.0,
        'maxGuests': 2,
        'description': 'Peaceful courtyard view room equipped with ergonomic workspace, ambient lighting, and high-speed Wi-Fi.',
        'amenities': ['Free Wi-Fi', 'AC', 'Work Desk', 'Breakfast'],
        'bookedRanges': [
          // R102 is booked right now (Today to +3 days) to demonstrate date availability collision
          {
            'checkIn': today.toIso8601String(),
            'checkOut': today.add(const Duration(days: 3)).toIso8601String(),
          },
        ],
      },
      {
        'code': 'R201',
        'type': 'Executive Suite',
        'pricePerNight': 5800.0,
        'maxGuests': 3,
        'description': 'Spacious luxury suite with separate living area, King bed, espresso machine, and premium lounge access.',
        'amenities': ['King Bed', 'Lounge Access', 'Coffee Maker', 'Bathtub'],
        'bookedRanges': [],
      },
      {
        'code': 'R202',
        'type': 'Executive Suite',
        'pricePerNight': 5800.0,
        'maxGuests': 3,
        'description': 'Elevated high-floor suite offering skyline views, premium rain shower, and complimentary spa access.',
        'amenities': ['Skyline View', 'Spa Access', 'King Bed', 'Free Wi-Fi'],
        'bookedRanges': [
          // R202 is booked from +2 days to +5 days
          {
            'checkIn': today.add(const Duration(days: 2)).toIso8601String(),
            'checkOut': today.add(const Duration(days: 5)).toIso8601String(),
          },
        ],
      },
      {
        'code': 'R301',
        'type': 'Family Room',
        'pricePerNight': 4200.0,
        'maxGuests': 4,
        'description': 'Versatile family-friendly accommodation with twin Queen beds, extra storage space, and kids entertainment pack.',
        'amenities': ['2 Queen Beds', '4 Guests', 'Kid Friendly', 'Smart TV'],
        'bookedRanges': [],
      },
    ];
  }

  @override
  Future<List<HotelRoomModel>> getRooms() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _getSampleData().map((e) => HotelRoomModel.fromJson(e)).toList();
  }
}
