import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/booking_summary.dart';
import '../../domain/entities/hotel_room.dart';
import '../../domain/usecases/calculate_booking.dart';
import '../../domain/usecases/get_hotel_rooms.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetHotelRoomsUseCase getHotelRoomsUseCase;
  final CalculateBookingUseCase calculateBookingUseCase;

  BookingBloc({
    required this.getHotelRoomsUseCase,
    required this.calculateBookingUseCase,
  }) : super(const BookingInitialState()) {
    on<LoadBookingDataEvent>(_onLoadBookingData);
    on<SelectRoomEvent>(_onSelectRoom);
    on<UpdateDatesEvent>(_onUpdateDates);
    on<SetCheckInEvent>(_onSetCheckIn);
    on<SetCheckOutEvent>(_onSetCheckOut);
    on<SetGuestCountEvent>(_onSetGuestCount);
  }

  Future<void> _onLoadBookingData(
    LoadBookingDataEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoadingState());

    try {
      final rooms = await getHotelRoomsUseCase.execute();

      final now = DateTime.now();
      final checkIn = DateTime(now.year, now.month, now.day);
      final checkOut = checkIn.add(const Duration(days: 2));
      const guestCount = 1;

      final filtered = rooms.where((r) => r.maxGuests >= guestCount).toList();
      final availableRooms = filtered.where((r) => !r.isBookedFor(checkIn, checkOut)).toList();

      HotelRoom? initialRoom;
      if (availableRooms.isNotEmpty) {
        initialRoom = availableRooms.first;
      } else if (filtered.isNotEmpty) {
        initialRoom = filtered.first;
      }

      final summary = calculateBookingUseCase.execute(
        selectedRoom: initialRoom,
        checkIn: checkIn,
        checkOut: checkOut,
        guestCount: guestCount,
      );

      emit(BookingLoadedState(
        rooms: rooms,
        selectedRoom: initialRoom,
        checkIn: checkIn,
        checkOut: checkOut,
        guestCount: guestCount,
        summary: summary,
      ));
    } catch (e) {
      emit(BookingErrorState(e.toString()));
    }
  }

  void _onSelectRoom(
    SelectRoomEvent event,
    Emitter<BookingState> emit,
  ) {
    if (state is! BookingLoadedState) return;
    final currentState = state as BookingLoadedState;

    final isTogglingSame = currentState.selectedRoom == event.room;
    final newRoom = isTogglingSame ? null : event.room;

    final summary = calculateBookingUseCase.execute(
      selectedRoom: newRoom,
      checkIn: currentState.checkIn,
      checkOut: currentState.checkOut,
      guestCount: currentState.guestCount,
    );

    emit(currentState.copyWith(
      selectedRoom: newRoom,
      clearSelectedRoom: isTogglingSame,
      summary: summary,
    ));
  }

  void _onUpdateDates(
    UpdateDatesEvent event,
    Emitter<BookingState> emit,
  ) {
    if (state is! BookingLoadedState) return;
    final currentState = state as BookingLoadedState;

    final summary = calculateBookingUseCase.execute(
      selectedRoom: currentState.selectedRoom,
      checkIn: event.checkIn,
      checkOut: event.checkOut,
      guestCount: currentState.guestCount,
    );

    emit(currentState.copyWith(
      checkIn: event.checkIn,
      checkOut: event.checkOut,
      summary: summary,
    ));
  }

  void _onSetCheckIn(
    SetCheckInEvent event,
    Emitter<BookingState> emit,
  ) {
    if (state is! BookingLoadedState) return;
    final currentState = state as BookingLoadedState;

    var checkOut = currentState.checkOut;
    if (checkOut != null && !checkOut.isAfter(event.checkIn)) {
      checkOut = event.checkIn.add(const Duration(days: 1));
    }

    final summary = calculateBookingUseCase.execute(
      selectedRoom: currentState.selectedRoom,
      checkIn: event.checkIn,
      checkOut: checkOut,
      guestCount: currentState.guestCount,
    );

    emit(currentState.copyWith(
      checkIn: event.checkIn,
      checkOut: checkOut,
      summary: summary,
    ));
  }

  void _onSetCheckOut(
    SetCheckOutEvent event,
    Emitter<BookingState> emit,
  ) {
    if (state is! BookingLoadedState) return;
    final currentState = state as BookingLoadedState;

    final summary = calculateBookingUseCase.execute(
      selectedRoom: currentState.selectedRoom,
      checkIn: currentState.checkIn,
      checkOut: event.checkOut,
      guestCount: currentState.guestCount,
    );

    emit(currentState.copyWith(
      checkOut: event.checkOut,
      summary: summary,
    ));
  }

  void _onSetGuestCount(
    SetGuestCountEvent event,
    Emitter<BookingState> emit,
  ) {
    if (state is! BookingLoadedState) return;
    final currentState = state as BookingLoadedState;

    if (event.guestCount < 1) return;

    HotelRoom? room = currentState.selectedRoom;
    bool clear = false;

    if (room != null && room.maxGuests < event.guestCount) {
      final validRooms = currentState.rooms.where((r) => r.maxGuests >= event.guestCount).toList();
      if (validRooms.isNotEmpty) {
        room = validRooms.first;
      } else {
        room = null;
        clear = true;
      }
    }

    final summary = calculateBookingUseCase.execute(
      selectedRoom: room,
      checkIn: currentState.checkIn,
      checkOut: currentState.checkOut,
      guestCount: event.guestCount,
    );

    emit(currentState.copyWith(
      guestCount: event.guestCount,
      selectedRoom: room,
      clearSelectedRoom: clear,
      summary: summary,
    ));
  }
}
