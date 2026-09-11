import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/hotel_booking/data/datasources/hotel_local_datasource.dart';
import 'features/hotel_booking/data/repositories/hotel_repository_impl.dart';
import 'features/hotel_booking/domain/usecases/calculate_booking.dart';
import 'features/hotel_booking/domain/usecases/get_hotel_rooms.dart';
import 'features/hotel_booking/presentation/bloc/booking_bloc.dart';
import 'features/hotel_booking/presentation/pages/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Clean Architecture Dependency Injection Setup
  final localDataSource = HotelLocalDataSourceImpl();
  final repository = HotelRepositoryImpl(localDataSource: localDataSource);
  final getHotelRoomsUseCase = GetHotelRoomsUseCase(repository);
  const calculateBookingUseCase = CalculateBookingUseCase();

  runApp(HotelBookingApp(
    getHotelRoomsUseCase: getHotelRoomsUseCase,
    calculateBookingUseCase: calculateBookingUseCase,
  ));
}

class HotelBookingApp extends StatelessWidget {
  final GetHotelRoomsUseCase getHotelRoomsUseCase;
  final CalculateBookingUseCase calculateBookingUseCase;

  const HotelBookingApp({
    super.key,
    required this.getHotelRoomsUseCase,
    required this.calculateBookingUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingBloc>(
      create: (context) => BookingBloc(
        getHotelRoomsUseCase: getHotelRoomsUseCase,
        calculateBookingUseCase: calculateBookingUseCase,
      ),
      child: MaterialApp(
        title: 'Hotel Room Booking',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashPage(),
      ),
    );
  }
}
