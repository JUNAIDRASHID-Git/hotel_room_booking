class HotelRoom {
  final String code;
  final String type;
  final double pricePerNight;
  final int maxGuests;
  final String description;
  final List<String> amenities;

  const HotelRoom({
    required this.code,
    required this.type,
    required this.pricePerNight,
    required this.maxGuests,
    required this.description,
    required this.amenities,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HotelRoom &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}
