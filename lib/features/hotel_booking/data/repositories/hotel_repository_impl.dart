import '../../domain/entities/hotel_room.dart';
import '../../domain/repositories/hotel_repository.dart';
import '../datasources/hotel_local_datasource.dart';

class HotelRepositoryImpl implements HotelRepository {
  final HotelLocalDataSource localDataSource;

  HotelRepositoryImpl({required this.localDataSource});

  @override
  Future<List<HotelRoom>> getHotelRooms() async {
    return await localDataSource.getRooms();
  }
}
