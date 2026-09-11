import '../../domain/entities/hotel_room.dart';

abstract class BookingEvent {
  const BookingEvent();
}

class LoadBookingDataEvent extends BookingEvent {
  const LoadBookingDataEvent();
}

class SelectRoomEvent extends BookingEvent {
  final HotelRoom room;
  const SelectRoomEvent(this.room);
}

class UpdateDatesEvent extends BookingEvent {
  final DateTime? checkIn;
  final DateTime? checkOut;
  const UpdateDatesEvent(this.checkIn, this.checkOut);
}

class SetCheckInEvent extends BookingEvent {
  final DateTime checkIn;
  const SetCheckInEvent(this.checkIn);
}

class SetCheckOutEvent extends BookingEvent {
  final DateTime checkOut;
  const SetCheckOutEvent(this.checkOut);
}

class SetGuestCountEvent extends BookingEvent {
  final int guestCount;
  const SetGuestCountEvent(this.guestCount);
}
