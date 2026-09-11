import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/features/hotel_booking/domain/entities/hotel_room.dart';
import 'package:hotel_booking/features/hotel_booking/domain/repositories/hotel_repository.dart';
import 'package:hotel_booking/features/hotel_booking/domain/usecases/calculate_booking.dart';
import 'package:hotel_booking/features/hotel_booking/domain/usecases/get_hotel_rooms.dart';
import 'package:hotel_booking/features/hotel_booking/presentation/bloc/booking_bloc.dart';
import 'package:hotel_booking/features/hotel_booking/presentation/bloc/booking_event.dart';
import 'package:hotel_booking/features/hotel_booking/presentation/bloc/booking_state.dart';

class FakeHotelRepository implements HotelRepository {
  @override
  Future<List<HotelRoom>> getHotelRooms() async {
    return const [
      HotelRoom(
        code: 'R101',
        type: 'Deluxe Room',
        pricePerNight: 3500.0,
        maxGuests: 2,
        description: 'Test Room',
        amenities: ['Wi-Fi'],
      ),
      HotelRoom(
        code: 'R301',
        type: 'Family Room',
        pricePerNight: 4200.0,
        maxGuests: 4,
        description: 'Family Room',
        amenities: ['2 Queen Beds'],
      ),
    ];
  }
}

void main() {
  late BookingBloc bookingBloc;
  late GetHotelRoomsUseCase getHotelRoomsUseCase;
  late CalculateBookingUseCase calculateBookingUseCase;

  setUp(() {
    final fakeRepo = FakeHotelRepository();
    getHotelRoomsUseCase = GetHotelRoomsUseCase(fakeRepo);
    calculateBookingUseCase = const CalculateBookingUseCase();

    bookingBloc = BookingBloc(
      getHotelRoomsUseCase: getHotelRoomsUseCase,
      calculateBookingUseCase: calculateBookingUseCase,
    );
  });

  tearDown(() {
    bookingBloc.close();
  });

  group('BookingBloc Tests', () {
    test('initial state should be BookingInitialState', () {
      expect(bookingBloc.state, isA<BookingInitialState>());
    });

    test('LoadBookingDataEvent should emit Loading then Loaded state with sample rooms', () async {
      final expectedStates = [
        isA<BookingLoadingState>(),
        isA<BookingLoadedState>(),
      ];

      expectLater(bookingBloc.stream, emitsInOrder(expectedStates));

      bookingBloc.add(const LoadBookingDataEvent());
    });

    test('SetGuestCountEvent should update guest count and filter rooms', () async {
      bookingBloc.add(const LoadBookingDataEvent());
      await Future.delayed(const Duration(milliseconds: 50));

      bookingBloc.add(const SetGuestCountEvent(3));
      await Future.delayed(const Duration(milliseconds: 50));

      final state = bookingBloc.state as BookingLoadedState;
      expect(state.guestCount, 3);
      expect(state.filteredRooms.length, 1); // Only R301 maxGuests = 4 >= 3
      expect(state.filteredRooms.first.code, 'R301');
    });

    test('SelectRoomEvent should toggle or change selected room', () async {
      bookingBloc.add(const LoadBookingDataEvent());
      await Future.delayed(const Duration(milliseconds: 50));

      final loadedState = bookingBloc.state as BookingLoadedState;
      final roomToSelect = loadedState.rooms.last;

      bookingBloc.add(SelectRoomEvent(roomToSelect));
      await Future.delayed(const Duration(milliseconds: 50));

      final updatedState = bookingBloc.state as BookingLoadedState;
      expect(updatedState.selectedRoom?.code, 'R301');
    });
  });
}
