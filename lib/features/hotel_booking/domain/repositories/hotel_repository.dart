import '../entities/hotel_room.dart';

abstract class HotelRepository {
  Future<List<HotelRoom>> getHotelRooms();
}
