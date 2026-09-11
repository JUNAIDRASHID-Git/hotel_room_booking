import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/hotel_booking/data/datasources/hotel_local_datasource.dart';
import 'features/hotel_booking/data/repositories/hotel_repository_impl.dart';
import 'features/hotel_booking/domain/usecases/calculate_booking.dart';
import 'features/hotel_booking/domain/usecases/get_hotel_rooms.dart';
import 'features/hotel_booking/presentation/controllers/booking_controller.dart';
import 'features/hotel_booking/presentation/pages/hotel_booking_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Clean Architecture Dependency Injection Setup
  final localDataSource = HotelLocalDataSourceImpl();
  final repository = HotelRepositoryImpl(localDataSource: localDataSource);
  final getHotelRoomsUseCase = GetHotelRoomsUseCase(repository);
  const calculateBookingUseCase = CalculateBookingUseCase();

  final bookingController = BookingController(
    getHotelRoomsUseCase: getHotelRoomsUseCase,
    calculateBookingUseCase: calculateBookingUseCase,
  );

  runApp(HotelBookingApp(bookingController: bookingController));
}

class HotelBookingApp extends StatelessWidget {
  final BookingController bookingController;

  const HotelBookingApp({
    super.key,
    required this.bookingController,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Room Booking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: HotelBookingPage(controller: bookingController),
    );
  }
}
