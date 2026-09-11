import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/core/failure/validation_failure.dart';
import 'package:hotel_booking/features/hotel_booking/domain/entities/hotel_room.dart';
import 'package:hotel_booking/features/hotel_booking/domain/usecases/calculate_booking.dart';

void main() {
  late CalculateBookingUseCase calculateBookingUseCase;
  late HotelRoom deluxeRoom;
  late DateTime mockToday;

  setUp(() {
    calculateBookingUseCase = const CalculateBookingUseCase();
    deluxeRoom = const HotelRoom(
      code: 'R101',
      type: 'Deluxe Room',
      pricePerNight: 3500.0,
      maxGuests: 2,
      description: 'Test Room',
      amenities: ['Wi-Fi'],
    );
    mockToday = DateTime(2026, 9, 11);
  });

  group('CalculateBookingUseCase Tests', () {
    test('should calculate correct nights and total price for valid booking', () {
      final checkIn = DateTime(2026, 9, 12);
      final checkOut = DateTime(2026, 9, 15); // 3 nights stay

      final result = calculateBookingUseCase.execute(
        selectedRoom: deluxeRoom,
        checkIn: checkIn,
        checkOut: checkOut,
        now: mockToday,
      );

      expect(result.isValid, true);
      expect(result.totalNights, 3);
      expect(result.totalPrice, 10500.0); // 3 * 3500
      expect(result.failure, null);
    });

    test('should return PastCheckInFailure when check-in is in the past', () {
      final checkIn = DateTime(2026, 9, 10); // Yesterday relative to mockToday
      final checkOut = DateTime(2026, 9, 12);

      final result = calculateBookingUseCase.execute(
        selectedRoom: deluxeRoom,
        checkIn: checkIn,
        checkOut: checkOut,
        now: mockToday,
      );

      expect(result.isValid, false);
      expect(result.failure, isA<PastCheckInFailure>());
    });

    test('should return InvalidCheckOutFailure when check-out is same day as check-in', () {
      final checkIn = DateTime(2026, 9, 12);
      final checkOut = DateTime(2026, 9, 12);

      final result = calculateBookingUseCase.execute(
        selectedRoom: deluxeRoom,
        checkIn: checkIn,
        checkOut: checkOut,
        now: mockToday,
      );

      expect(result.isValid, false);
      expect(result.failure, isA<InvalidCheckOutFailure>());
    });

    test('should return InvalidCheckOutFailure when check-out is before check-in', () {
      final checkIn = DateTime(2026, 9, 14);
      final checkOut = DateTime(2026, 9, 12);

      final result = calculateBookingUseCase.execute(
        selectedRoom: deluxeRoom,
        checkIn: checkIn,
        checkOut: checkOut,
        now: mockToday,
      );

      expect(result.isValid, false);
      expect(result.failure, isA<InvalidCheckOutFailure>());
    });

    test('should return RoomNotSelectedFailure when selectedRoom is null but dates are valid', () {
      final checkIn = DateTime(2026, 9, 12);
      final checkOut = DateTime(2026, 9, 15);

      final result = calculateBookingUseCase.execute(
        selectedRoom: null,
        checkIn: checkIn,
        checkOut: checkOut,
        now: mockToday,
      );

      expect(result.isValid, false);
      expect(result.totalNights, 3);
      expect(result.failure, isA<RoomNotSelectedFailure>());
    });

    test('should return MissingDatesFailure when checkIn or checkOut is null', () {
      final result = calculateBookingUseCase.execute(
        selectedRoom: deluxeRoom,
        checkIn: null,
        checkOut: null,
        now: mockToday,
      );

      expect(result.isValid, false);
      expect(result.failure, isA<MissingDatesFailure>());
    });
  });
}
