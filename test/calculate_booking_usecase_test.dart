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
    mockToday = DateTime(2026, 9, 11);
    deluxeRoom = HotelRoom(
      code: 'R101',
      type: 'Deluxe Room',
      pricePerNight: 3500.0,
      maxGuests: 2,
      description: 'Test Room',
      amenities: ['Wi-Fi'],
      bookedRanges: [
        BookingDateRange(
          checkIn: DateTime(2026, 9, 15),
          checkOut: DateTime(2026, 9, 18),
        ),
      ],
    );
  });

  group('CalculateBookingUseCase Tests', () {
    test('should calculate correct nights and total price for valid booking', () {
      final checkIn = DateTime(2026, 9, 12);
      final checkOut = DateTime(2026, 9, 15); // 3 nights stay (ends before R101 existing booking)

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

    test('should return RoomAlreadyBookedFailure when dates overlap with existing booking', () {
      final checkIn = DateTime(2026, 9, 14);
      final checkOut = DateTime(2026, 9, 17); // Overlaps with 9/15 - 9/18

      final result = calculateBookingUseCase.execute(
        selectedRoom: deluxeRoom,
        checkIn: checkIn,
        checkOut: checkOut,
        now: mockToday,
      );

      expect(result.isValid, false);
      expect(result.failure, isA<RoomAlreadyBookedFailure>());
      expect((result.failure as RoomAlreadyBookedFailure).roomCode, 'R101');
    });

    test('should return ExceedsMaxGuestsFailure when guest count exceeds room capacity', () {
      final checkIn = DateTime(2026, 9, 12);
      final checkOut = DateTime(2026, 9, 14);

      final result = calculateBookingUseCase.execute(
        selectedRoom: deluxeRoom, // maxGuests = 2
        checkIn: checkIn,
        checkOut: checkOut,
        guestCount: 4, // 4 guests > max 2
        now: mockToday,
      );

      expect(result.isValid, false);
      expect(result.failure, isA<ExceedsMaxGuestsFailure>());
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
