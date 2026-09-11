import '../../domain/entities/booking_summary.dart';
import '../../domain/entities/hotel_room.dart';

abstract class BookingState {
  const BookingState();
}

class BookingInitialState extends BookingState {
  const BookingInitialState();
}

class BookingLoadingState extends BookingState {
  const BookingLoadingState();
}

class BookingLoadedState extends BookingState {
  final List<HotelRoom> rooms;
  final HotelRoom? selectedRoom;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int guestCount;
  final BookingSummary summary;

  const BookingLoadedState({
    required this.rooms,
    this.selectedRoom,
    this.checkIn,
    this.checkOut,
    this.guestCount = 1,
    required this.summary,
  });

  List<HotelRoom> get filteredRooms =>
      rooms.where((r) => r.maxGuests >= guestCount).toList();

  BookingLoadedState copyWith({
    List<HotelRoom>? rooms,
    HotelRoom? selectedRoom,
    bool clearSelectedRoom = false,
    DateTime? checkIn,
    DateTime? checkOut,
    int? guestCount,
    BookingSummary? summary,
  }) {
    return BookingLoadedState(
      rooms: rooms ?? this.rooms,
      selectedRoom: clearSelectedRoom ? null : (selectedRoom ?? this.selectedRoom),
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      guestCount: guestCount ?? this.guestCount,
      summary: summary ?? this.summary,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingLoadedState &&
          runtimeType == other.runtimeType &&
          selectedRoom == other.selectedRoom &&
          checkIn == other.checkIn &&
          checkOut == other.checkOut &&
          guestCount == other.guestCount &&
          summary == other.summary &&
          rooms.length == other.rooms.length;

  @override
  int get hashCode =>
      selectedRoom.hashCode ^
      checkIn.hashCode ^
      checkOut.hashCode ^
      guestCount.hashCode ^
      summary.hashCode;
}

class BookingErrorState extends BookingState {
  final String message;
  const BookingErrorState(this.message);
}
