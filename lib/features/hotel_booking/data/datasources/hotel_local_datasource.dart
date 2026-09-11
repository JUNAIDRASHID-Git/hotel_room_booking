import '../models/hotel_room_model.dart';

abstract class HotelLocalDataSource {
  Future<List<HotelRoomModel>> getRooms();
}

class HotelLocalDataSourceImpl implements HotelLocalDataSource {
  static const List<Map<String, dynamic>> _sampleData = [
    {
      'code': 'R101',
      'type': 'Deluxe Room',
      'pricePerNight': 3500.0,
      'maxGuests': 2,
      'description': 'Modern, cozy sanctuary featuring a plush Queen bed, marble bathroom, and panoramic city views.',
      'amenities': ['Free Wi-Fi', 'AC', 'TV', 'Mini Bar'],
    },
    {
      'code': 'R102',
      'type': 'Deluxe Room',
      'pricePerNight': 3500.0,
      'maxGuests': 2,
      'description': 'Peaceful courtyard view room equipped with ergonomic workspace, ambient lighting, and high-speed Wi-Fi.',
      'amenities': ['Free Wi-Fi', 'AC', 'Work Desk', 'Breakfast'],
    },
    {
      'code': 'R201',
      'type': 'Executive Suite',
      'pricePerNight': 5800.0,
      'maxGuests': 3,
      'description': 'Spacious luxury suite with separate living area, King bed, espresso machine, and premium lounge access.',
      'amenities': ['King Bed', 'Lounge Access', 'Coffee Maker', 'Bathtub'],
    },
    {
      'code': 'R202',
      'type': 'Executive Suite',
      'pricePerNight': 5800.0,
      'maxGuests': 3,
      'description': 'Elevated high-floor suite offering skyline views, premium rain shower, and complimentary spa access.',
      'amenities': ['Skyline View', 'Spa Access', 'King Bed', 'Free Wi-Fi'],
    },
    {
      'code': 'R301',
      'type': 'Family Room',
      'pricePerNight': 4200.0,
      'maxGuests': 4,
      'description': 'Versatile family-friendly accommodation with twin Queen beds, extra storage space, and kids entertainment pack.',
      'amenities': ['2 Queen Beds', '4 Guests', 'Kid Friendly', 'Smart TV'],
    },
  ];

  @override
  Future<List<HotelRoomModel>> getRooms() async {
    // Simulate slight network latency for realistic feel
    await Future.delayed(const Duration(milliseconds: 300));
    return _sampleData.map((e) => HotelRoomModel.fromJson(e)).toList();
  }
}
