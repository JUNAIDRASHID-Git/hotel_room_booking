import 'package:flutter/foundation.dart';
import '../../domain/entities/booking_summary.dart';
import '../../domain/entities/hotel_room.dart';
import '../../domain/usecases/calculate_booking.dart';
import '../../domain/usecases/get_hotel_rooms.dart';

class BookingController extends ChangeNotifier {
  final GetHotelRoomsUseCase getHotelRoomsUseCase;
  final CalculateBookingUseCase calculateBookingUseCase;

  BookingController({
    required this.getHotelRoomsUseCase,
    required this.calculateBookingUseCase,
  });

  List<HotelRoom> _rooms = [];
  List<HotelRoom> get rooms => _rooms;

  HotelRoom? _selectedRoom;
  HotelRoom? get selectedRoom => _selectedRoom;

  DateTime? _checkIn;
  DateTime? get checkIn => _checkIn;

  DateTime? _checkOut;
  DateTime? get checkOut => _checkOut;

  BookingSummary _summary = const BookingSummary(failure: null);
  BookingSummary get summary => _summary;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      _rooms = await getHotelRoomsUseCase.execute();
      
      // Default dates for seamless initial preview (Today -> +2 Days)
      final now = DateTime.now();
      _checkIn = DateTime(now.year, now.month, now.day);
      _checkOut = _checkIn!.add(const Duration(days: 2));

      // Pre-select first room for high conversion UI experience
      if (_rooms.isNotEmpty) {
        _selectedRoom = _rooms.first;
      }
      
      _recalculate();
    } catch (e) {
      // Handle potential fetch errors cleanly
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectRoom(HotelRoom room) {
    if (_selectedRoom == room) {
      // Unselect room if tapped again
      _selectedRoom = null;
    } else {
      _selectedRoom = room;
    }
    _recalculate();
    notifyListeners();
  }

  void updateDates(DateTime? newCheckIn, DateTime? newCheckOut) {
    _checkIn = newCheckIn;
    _checkOut = newCheckOut;
    _recalculate();
    notifyListeners();
  }

  void setCheckIn(DateTime date) {
    _checkIn = date;
    // Auto-adjust check-out if check-out is now before or on check-in
    if (_checkOut != null && !_checkOut!.isAfter(_checkIn!)) {
      _checkOut = _checkIn!.add(const Duration(days: 1));
    }
    _recalculate();
    notifyListeners();
  }

  void setCheckOut(DateTime date) {
    _checkOut = date;
    _recalculate();
    notifyListeners();
  }

  void _recalculate() {
    _summary = calculateBookingUseCase.execute(
      selectedRoom: _selectedRoom,
      checkIn: _checkIn,
      checkOut: _checkOut,
    );
  }
}
