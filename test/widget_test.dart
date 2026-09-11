import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/features/hotel_booking/data/datasources/hotel_local_datasource.dart';
import 'package:hotel_booking/features/hotel_booking/data/repositories/hotel_repository_impl.dart';
import 'package:hotel_booking/features/hotel_booking/domain/usecases/calculate_booking.dart';
import 'package:hotel_booking/features/hotel_booking/domain/usecases/get_hotel_rooms.dart';
import 'package:hotel_booking/main.dart';

void main() {
  testWidgets('Hotel Booking App renders splash screen then main booking page', (WidgetTester tester) async {
    final localDataSource = HotelLocalDataSourceImpl();
    final repository = HotelRepositoryImpl(localDataSource: localDataSource);
    final getHotelRoomsUseCase = GetHotelRoomsUseCase(repository);
    const calculateBookingUseCase = CalculateBookingUseCase();

    await tester.pumpWidget(HotelBookingApp(
      getHotelRoomsUseCase: getHotelRoomsUseCase,
      calculateBookingUseCase: calculateBookingUseCase,
    ));

    // Verify Splash Screen appears initially
    expect(find.text('RainTech Stays'), findsOneWidget);

    // Wait for Splash screen animation timer (1800ms + page transition)
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();

    // Verify main page renders
    expect(find.text('Hotel Room Booking'), findsOneWidget);
    expect(find.text('Select Stay Dates'), findsOneWidget);
    expect(find.text('Available Rooms'), findsOneWidget);
  });
}
