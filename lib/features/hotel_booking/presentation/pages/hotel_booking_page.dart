import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../controllers/booking_controller.dart';
import '../widgets/booking_summary_card.dart';
import '../widgets/date_selection_card.dart';
import '../widgets/room_card.dart';
import '../widgets/validation_banner.dart';

class HotelBookingPage extends StatefulWidget {
  final BookingController controller;

  const HotelBookingPage({
    super.key,
    required this.controller,
  });

  @override
  State<HotelBookingPage> createState() => _HotelBookingPageState();
}

class _HotelBookingPageState extends State<HotelBookingPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.init();
  }

  void _showBookingConfirmationDialog(BuildContext context) {
    final summary = widget.controller.summary;
    final room = summary.selectedRoom;

    if (room == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: const [
              Icon(Icons.verified_rounded, color: AppColors.secondaryAccent, size: 28),
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
                    _dialogInfoRow('Total Amount', CurrencyFormatter.formatINR(summary.totalPrice), isBold: true),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final controller = widget.controller;

        return Scaffold(
          body: CustomScrollView(
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
                      Icon(Icons.king_bed_rounded, color: Colors.amber, size: 24),
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
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Page Body Content
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (controller.isLoading)
                      const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else ...[
                      // Section 1: Date Picker Card
                      DateSelectionCard(
                        checkIn: controller.checkIn,
                        checkOut: controller.checkOut,
                        onCheckInSelected: controller.setCheckIn,
                        onCheckOutSelected: controller.setCheckOut,
                        onDateRangeSelected: (range) {
                          controller.updateDates(range.start, range.end);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Section 2: Validation Message Banner
                      ValidationBanner(failure: controller.summary.failure),

                      const SizedBox(height: 8),

                      // Section 3: Room Selection List Header
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
                              '${controller.rooms.length} Options',
                              style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // List of Rooms
                      ...controller.rooms.map((room) {
                        return RoomCard(
                          room: room,
                          isSelected: controller.selectedRoom == room,
                          onTap: () => controller.selectRoom(room),
                        );
                      }).toList(),

                      const SizedBox(height: 12),

                      // Section 4: Live Price & Nights Summary Calculation Card
                      BookingSummaryCard(
                        summary: controller.summary,
                        onBookNowPressed: () => _showBookingConfirmationDialog(context),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
