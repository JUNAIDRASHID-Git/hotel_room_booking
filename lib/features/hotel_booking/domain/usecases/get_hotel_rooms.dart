import '../entities/hotel_room.dart';
import '../repositories/hotel_repository.dart';

class GetHotelRoomsUseCase {
  final HotelRepository repository;

  GetHotelRoomsUseCase(this.repository);

  Future<List<HotelRoom>> execute() {
    return repository.getHotelRooms();
  }
}
