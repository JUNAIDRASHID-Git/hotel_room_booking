import '../../../../core/failure/validation_failure.dart';
import '../entities/booking_summary.dart';
import '../entities/hotel_room.dart';

class CalculateBookingUseCase {
  const CalculateBookingUseCase();

  BookingSummary execute({
    required HotelRoom? selectedRoom,
    required DateTime? checkIn,
    required DateTime? checkOut,
    DateTime? now,
  }) {
    if (checkIn == null || checkOut == null) {
      return BookingSummary(
        selectedRoom: selectedRoom,
        checkIn: checkIn,
        checkOut: checkOut,
        failure: const MissingDatesFailure(),
      );
    }

    final currentDate = now ?? DateTime.now();
    final todayNormalized = DateTime(currentDate.year, currentDate.month, currentDate.day);
    final checkInNormalized = DateTime(checkIn.year, checkIn.month, checkIn.day);
    final checkOutNormalized = DateTime(checkOut.year, checkOut.month, checkOut.day);

    if (checkInNormalized.isBefore(todayNormalized)) {
      return BookingSummary(
        selectedRoom: selectedRoom,
        checkIn: checkIn,
        checkOut: checkOut,
        failure: const PastCheckInFailure(),
      );
    }

    if (!checkOutNormalized.isAfter(checkInNormalized)) {
      return BookingSummary(
        selectedRoom: selectedRoom,
        checkIn: checkIn,
        checkOut: checkOut,
        failure: const InvalidCheckOutFailure(),
      );
    }

    final nights = checkOutNormalized.difference(checkInNormalized).inDays;

    if (selectedRoom == null) {
      return BookingSummary(
        selectedRoom: null,
        checkIn: checkIn,
        checkOut: checkOut,
        totalNights: nights,
        failure: const RoomNotSelectedFailure(),
      );
    }

    final totalPrice = nights * selectedRoom.pricePerNight;

    return BookingSummary(
      selectedRoom: selectedRoom,
      checkIn: checkIn,
      checkOut: checkOut,
      totalNights: nights,
      totalPrice: totalPrice,
      failure: null,
    );
  }
}
