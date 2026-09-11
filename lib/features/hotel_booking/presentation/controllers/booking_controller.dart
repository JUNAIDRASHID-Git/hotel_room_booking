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

  int _guestCount = 1;
  int get guestCount => _guestCount;

  List<HotelRoom> get filteredRooms =>
      _rooms.where((room) => room.maxGuests >= _guestCount).toList();

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

      final now = DateTime.now();
      _checkIn = DateTime(now.year, now.month, now.day);
      _checkOut = _checkIn!.add(const Duration(days: 2));

      // Select first available room for the default dates
      final availableRooms = filteredRooms.where((r) => !r.isBookedFor(_checkIn, _checkOut)).toList();
      if (availableRooms.isNotEmpty) {
        _selectedRoom = availableRooms.first;
      } else if (filteredRooms.isNotEmpty) {
        _selectedRoom = filteredRooms.first;
      }

      _recalculate();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setGuestCount(int count) {
    if (count < 1) return;
    _guestCount = count;

    // If currently selected room doesn't accommodate new guest count, auto switch or clear
    if (_selectedRoom != null && _selectedRoom!.maxGuests < _guestCount) {
      final validRooms = filteredRooms;
      _selectedRoom = validRooms.isNotEmpty ? validRooms.first : null;
    }

    _recalculate();
    notifyListeners();
  }

  void selectRoom(HotelRoom room) {
    if (_selectedRoom == room) {
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
      guestCount: _guestCount,
    );
  }
}
