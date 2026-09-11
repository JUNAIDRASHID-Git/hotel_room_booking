import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/booking_summary.dart';

class BookingSummaryCard extends StatelessWidget {
  final BookingSummary summary;
  final VoidCallback onBookNowPressed;

  const BookingSummaryCard({
    super.key,
    required this.summary,
    required this.onBookNowPressed,
  });

  @override
  Widget build(BuildContext context) {
    final room = summary.selectedRoom;
    final isComplete = summary.isValid;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.receipt_long_rounded, color: AppColors.primaryAccent, size: 22),
              SizedBox(width: 8),
              Text('Booking Calculation', style: AppTextStyles.heading2),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 16),

          // Room Details Row
          _buildRow(
            label: 'Selected Room',
            value: room != null ? '${room.type} (${room.code})' : 'Not Selected',
            isBold: room != null,
          ),
          const SizedBox(height: 10),

          // Price per Night Row
          _buildRow(
            label: 'Rate / Night',
            value: room != null ? CurrencyFormatter.formatINR(room.pricePerNight) : '₹0',
          ),
          const SizedBox(height: 10),

          // Duration Row
          _buildRow(
            label: 'Total Nights',
            value: summary.totalNights > 0 ? '${summary.totalNights} Night${summary.totalNights > 1 ? 's' : ''}' : '-',
            valueColor: summary.totalNights > 0 ? AppColors.primaryAccent : AppColors.textMuted,
          ),
          const SizedBox(height: 10),

          // Dates Summary Row
          _buildRow(
            label: 'Stay Duration',
            value: (summary.checkIn != null && summary.checkOut != null)
                ? '${DateFormatter.formatShort(summary.checkIn)} → ${DateFormatter.formatShort(summary.checkOut)}'
                : 'Dates required',
            isSmall: true,
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 16),

          // Total Calculation Highlight
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Price', style: AppTextStyles.title),
                  Text(
                    summary.totalNights > 0 && room != null
                        ? '(${summary.totalNights} × ${CurrencyFormatter.formatINR(room.pricePerNight)})'
                        : 'Select room and valid dates',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
              Text(
                isComplete ? CurrencyFormatter.formatINR(summary.totalPrice) : '₹0',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isComplete ? AppColors.primaryAccent : AppColors.textMuted,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // CTA Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isComplete ? onBookNowPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                disabledBackgroundColor: AppColors.border,
                elevation: isComplete ? 2 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    isComplete ? 'Confirm Room Booking' : 'Complete Selection to Book',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isComplete ? Colors.white : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required String value,
    bool isBold = false,
    bool isSmall = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMuted.copyWith(
            fontSize: isSmall ? 12 : 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmall ? 12 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
