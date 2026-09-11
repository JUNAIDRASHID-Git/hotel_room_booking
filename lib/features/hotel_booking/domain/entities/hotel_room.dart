class BookingDateRange {
  final DateTime checkIn;
  final DateTime checkOut;

  const BookingDateRange({
    required this.checkIn,
    required this.checkOut,
  });

  bool overlapsWith(DateTime start, DateTime end) {
    final s1 = DateTime(checkIn.year, checkIn.month, checkIn.day);
    final e1 = DateTime(checkOut.year, checkOut.month, checkOut.day);
    final s2 = DateTime(start.year, start.month, start.day);
    final e2 = DateTime(end.year, end.month, end.day);

    return s1.isBefore(e2) && e1.isAfter(s2);
  }
}

class HotelRoom {
  final String code;
  final String type;
  final double pricePerNight;
  final int maxGuests;
  final String description;
  final List<String> amenities;
  final List<BookingDateRange> bookedRanges;

  const HotelRoom({
    required this.code,
    required this.type,
    required this.pricePerNight,
    required this.maxGuests,
    required this.description,
    required this.amenities,
    this.bookedRanges = const [],
  });

  bool isBookedFor(DateTime? start, DateTime? end) {
    if (start == null || end == null) return false;
    return bookedRanges.any((range) => range.overlapsWith(start, end));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HotelRoom &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}
