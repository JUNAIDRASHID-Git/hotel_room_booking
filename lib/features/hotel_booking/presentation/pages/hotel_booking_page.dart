import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../widgets/booking_summary_card.dart';
import '../widgets/date_selection_card.dart';
import '../widgets/room_card.dart';
import '../widgets/shimmer_skeletons.dart';
import '../widgets/validation_banner.dart';

class HotelBookingPage extends StatefulWidget {
  const HotelBookingPage({super.key});

  @override
  State<HotelBookingPage> createState() => _HotelBookingPageState();
}

class _HotelBookingPageState extends State<HotelBookingPage> {
  @override
  void initState() {
    super.initState();
    // Dispatch initial load event
    context.read<BookingBloc>().add(const LoadBookingDataEvent());
  }

  void _showBookingConfirmationDialog(BuildContext context, BookingLoadedState state) {
    final summary = state.summary;
    final room = summary.selectedRoom;

    if (room == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: const [
              Icon(
                Icons.verified_rounded,
                color: AppColors.secondaryAccent,
                size: 28,
              ),
              SizedBox(width: 10),
              Text('Reservation Confirmed!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your stay for ${room.type} (${room.code}) is successfully reserved.',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _dialogInfoRow('Check-in', DateFormatter.formatShort(summary.checkIn)),
                    const SizedBox(height: 6),
                    _dialogInfoRow('Check-out', DateFormatter.formatShort(summary.checkOut)),
                    const SizedBox(height: 6),
                    _dialogInfoRow('Total Stay', '${summary.totalNights} Nights'),
                    const SizedBox(height: 6),
                    _dialogInfoRow('Guests', '${state.guestCount} Guest(s)'),
                    const SizedBox(height: 6),
                    _dialogInfoRow(
                      'Total Amount',
                      CurrencyFormatter.formatINR(summary.totalPrice),
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _dialogInfoRow(String label, String val, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 12)),
        Text(
          val,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? AppColors.primaryAccent : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BookingBloc>();

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Sleek App Bar Header
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Row(
                children: const [
                  Icon(
                    Icons.king_bed_rounded,
                    color: Colors.amber,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Hotel Room Booking',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                    ),
                  ),
                  Positioned(
                    right: -30,
                    top: -30,
                    child: Icon(
                      Icons.hotel_rounded,
                      size: 180,
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Body with BLoC State handling
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                BlocBuilder<BookingBloc, BookingState>(
                  builder: (context, state) {
                    if (state is BookingLoadingState || state is BookingInitialState) {
                      return Column(
                        children: const [
                          DateSelectionSkeleton(),
                          SizedBox(height: 16),
                          GuestFilterSkeleton(),
                          SizedBox(height: 20),
                          RoomCardSkeleton(),
                          RoomCardSkeleton(),
                          RoomCardSkeleton(),
                          SizedBox(height: 12),
                          BookingSummarySkeleton(),
                        ],
                      );
                    }

                    if (state is BookingErrorState) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: [
                              const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.errorText),
                              const SizedBox(height: 12),
                              Text(state.message, style: AppTextStyles.body),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => bloc.add(const LoadBookingDataEvent()),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is BookingLoadedState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section 1: Date Picker Card (Isolated RepaintBoundary)
                          RepaintBoundary(
                            child: DateSelectionCard(
                              checkIn: state.checkIn,
                              checkOut: state.checkOut,
                              onCheckInSelected: (date) => bloc.add(SetCheckInEvent(date)),
                              onCheckOutSelected: (date) => bloc.add(SetCheckOutEvent(date)),
                              onDateRangeSelected: (range) => bloc.add(UpdateDatesEvent(range.start, range.end)),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Section 2: Guest Count Filter Card (Isolated RepaintBoundary)
                          RepaintBoundary(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.people_alt_rounded, color: AppColors.primaryAccent, size: 20),
                                  const SizedBox(width: 8),
                                  const Text('Guests:', style: AppTextStyles.title),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [1, 2, 3, 4].map((count) {
                                          final isSelected = state.guestCount == count;
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 6),
                                            child: ChoiceChip(
                                              label: Text('$count ${count == 1 ? "Guest" : "Guests"}'),
                                              selected: isSelected,
                                              selectedColor: AppColors.primaryAccent,
                                              labelStyle: TextStyle(
                                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                fontSize: 12,
                                              ),
                                              onSelected: (_) => bloc.add(SetGuestCountEvent(count)),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Section 3: Validation Banner
                          ValidationBanner(failure: state.summary.failure),

                          const SizedBox(height: 8),

                          // Section 4: Available Rooms Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Available Rooms', style: AppTextStyles.heading1),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${state.filteredRooms.length} of ${state.rooms.length} Rooms',
                                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Filtered Room List (RepaintBoundary per room)
                          ...state.filteredRooms.map((room) {
                            return RepaintBoundary(
                              key: ValueKey(room.code),
                              child: RoomCard(
                                room: room,
                                isSelected: state.selectedRoom == room,
                                checkIn: state.checkIn,
                                checkOut: state.checkOut,
                                onTap: () => bloc.add(SelectRoomEvent(room)),
                              ),
                            );
                          }),

                          const SizedBox(height: 12),

                          // Section 5: Booking Summary Card (Isolated RepaintBoundary)
                          RepaintBoundary(
                            child: BookingSummaryCard(
                              summary: state.summary,
                              onBookNowPressed: () => _showBookingConfirmationDialog(context, state),
                            ),
                          ),

                          const SizedBox(height: 30),
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
