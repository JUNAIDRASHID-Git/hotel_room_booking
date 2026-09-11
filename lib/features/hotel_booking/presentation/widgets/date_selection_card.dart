import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';

class DateSelectionCard extends StatelessWidget {
  final DateTime? checkIn;
  final DateTime? checkOut;
  final Function(DateTimeRange) onDateRangeSelected;

  const DateSelectionCard({
    super.key,
    required this.checkIn,
    required this.checkOut,
    required this.onDateRangeSelected,
  });

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final initialRange =
        (checkIn != null && checkOut != null && checkOut!.isAfter(checkIn!))
            ? DateTimeRange(start: checkIn!, end: checkOut!)
            : DateTimeRange(start: now, end: now.add(const Duration(days: 2)));

    final range = await showDateRangePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: initialRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryAccent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (range != null) {
      onDateRangeSelected(range);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.calendar_month_rounded,
                color: AppColors.primaryAccent,
                size: 22,
              ),
              SizedBox(width: 8),
              Text('Select Stay Dates', style: AppTextStyles.heading2),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDateTile(
                  context,
                  label: 'CHECK-IN',
                  dateStr: DateFormatter.formatShort(checkIn),
                  icon: Icons.flight_land_rounded,
                  onTap: () => _pickDateRange(context),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.textMuted,
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateTile(
                  context,
                  label: 'CHECK-OUT',
                  dateStr: DateFormatter.formatShort(checkOut),
                  icon: Icons.flight_takeoff_rounded,
                  onTap: () => _pickDateRange(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateTile(
    BuildContext context, {
    required String label,
    required String dateStr,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(icon, size: 16, color: AppColors.primaryAccent),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      dateStr,
                      style: AppTextStyles.title.copyWith(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
