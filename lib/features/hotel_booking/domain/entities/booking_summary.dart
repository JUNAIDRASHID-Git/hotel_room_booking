import '../../../../core/failure/validation_failure.dart';
import 'hotel_room.dart';

class BookingSummary {
  final HotelRoom? selectedRoom;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int totalNights;
  final double totalPrice;
  final ValidationFailure? failure;

  const BookingSummary({
    this.selectedRoom,
    this.checkIn,
    this.checkOut,
    this.totalNights = 0,
    this.totalPrice = 0.0,
    this.failure,
  });

  bool get isValid =>
      failure == null &&
      selectedRoom != null &&
      checkIn != null &&
      checkOut != null &&
      totalNights > 0;
}
