import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';

class ShimmerSkeleton extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const ShimmerSkeleton({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class DateSelectionSkeleton extends StatelessWidget {
  const DateSelectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ShimmerSkeleton(height: 22, width: 160, borderRadius: 6),
              ShimmerSkeleton(height: 20, width: 90, borderRadius: 6),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: ShimmerSkeleton(height: 54, width: double.infinity, borderRadius: 12)),
              SizedBox(width: 12),
              ShimmerSkeleton(height: 18, width: 18, borderRadius: 9),
              SizedBox(width: 12),
              Expanded(child: ShimmerSkeleton(height: 54, width: double.infinity, borderRadius: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class GuestFilterSkeleton extends StatelessWidget {
  const GuestFilterSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: const [
          ShimmerSkeleton(height: 20, width: 20, borderRadius: 10),
          SizedBox(width: 8),
          ShimmerSkeleton(height: 18, width: 60, borderRadius: 6),
          SizedBox(width: 12),
          ShimmerSkeleton(height: 32, width: 70, borderRadius: 16),
          SizedBox(width: 6),
          ShimmerSkeleton(height: 32, width: 70, borderRadius: 16),
          SizedBox(width: 6),
          ShimmerSkeleton(height: 32, width: 70, borderRadius: 16),
        ],
      ),
    );
  }
}

class RoomCardSkeleton extends StatelessWidget {
  const RoomCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              ShimmerSkeleton(height: 28, width: 64, borderRadius: 8),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerSkeleton(height: 18, width: 120, borderRadius: 6),
                    SizedBox(height: 6),
                    ShimmerSkeleton(height: 14, width: 90, borderRadius: 4),
                  ],
                ),
              ),
              ShimmerSkeleton(height: 22, width: 60, borderRadius: 6),
            ],
          ),
          const SizedBox(height: 12),
          const ShimmerSkeleton(height: 14, width: double.infinity, borderRadius: 4),
          const SizedBox(height: 6),
          const ShimmerSkeleton(height: 14, width: 200, borderRadius: 4),
          const SizedBox(height: 12),
          Row(
            children: const [
              ShimmerSkeleton(height: 22, width: 60, borderRadius: 6),
              SizedBox(width: 6),
              ShimmerSkeleton(height: 22, width: 50, borderRadius: 6),
              SizedBox(width: 6),
              ShimmerSkeleton(height: 22, width: 70, borderRadius: 6),
            ],
          ),
        ],
      ),
    );
  }
}

class BookingSummarySkeleton extends StatelessWidget {
  const BookingSummarySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ShimmerSkeleton(height: 22, width: 180, borderRadius: 6),
          SizedBox(height: 16),
          ShimmerSkeleton(height: 16, width: double.infinity, borderRadius: 4),
          SizedBox(height: 10),
          ShimmerSkeleton(height: 16, width: double.infinity, borderRadius: 4),
          SizedBox(height: 10),
          ShimmerSkeleton(height: 16, width: 220, borderRadius: 4),
          SizedBox(height: 20),
          ShimmerSkeleton(height: 50, width: double.infinity, borderRadius: 14),
        ],
      ),
    );
  }
}
