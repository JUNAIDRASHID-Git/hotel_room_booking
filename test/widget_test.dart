import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/features/hotel_booking/data/datasources/hotel_local_datasource.dart';
import 'package:hotel_booking/features/hotel_booking/data/repositories/hotel_repository_impl.dart';
import 'package:hotel_booking/features/hotel_booking/domain/usecases/calculate_booking.dart';
import 'package:hotel_booking/features/hotel_booking/domain/usecases/get_hotel_rooms.dart';
import 'package:hotel_booking/features/hotel_booking/presentation/controllers/booking_controller.dart';
import 'package:hotel_booking/main.dart';

void main() {
  testWidgets('Hotel Booking App renders title and rooms', (WidgetTester tester) async {
    final localDataSource = HotelLocalDataSourceImpl();
    final repository = HotelRepositoryImpl(localDataSource: localDataSource);
    final getHotelRoomsUseCase = GetHotelRoomsUseCase(repository);
    const calculateBookingUseCase = CalculateBookingUseCase();

    final bookingController = BookingController(
      getHotelRoomsUseCase: getHotelRoomsUseCase,
      calculateBookingUseCase: calculateBookingUseCase,
    );

    await tester.pumpWidget(HotelBookingApp(bookingController: bookingController));
    await tester.pumpAndSettle();

    expect(find.text('Hotel Room Booking'), findsOneWidget);
    expect(find.text('Select Stay Dates'), findsOneWidget);
    expect(find.text('Available Rooms'), findsOneWidget);
  });
}
