import 'package:flutter/material.dart';
import '../theme.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const PrimaryButton({super.key, required this.label, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.purple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          onPressed: onPressed,
          child: Text(label, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}

class PillButton extends StatelessWidget {
  final String label;
  final bool primary;
  final VoidCallback? onPressed;
  const PillButton({super.key, required this.label, this.primary = false, this.onPressed});
  @override
  Widget build(BuildContext context) {
    final bg = primary ? AppColors.purple : const Color(0xFFF4F5F7);
    final fg = primary ? Colors.white : AppColors.textSecondary;
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;
  const SectionTitle({super.key, required this.title, this.actionText, this.onAction});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20))),
          if (actionText != null)
            TextButton(onPressed: onAction, child: Text(actionText!, style: const TextStyle(color: AppColors.textSecondary))),
        ],
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  final double rating;
  const RatingStars({super.key, required this.rating});
  @override
  Widget build(BuildContext context) {
    final full = rating.floor();
    final half = (rating - full) >= 0.5;
    return Row(
      children: List.generate(5, (i) {
        final color = i < full || (half && i == full) ? AppColors.orange : AppColors.divider;
        return Icon(Icons.star, color: color, size: 16);
      }),
    );
  }
}

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onInc;
  final VoidCallback onDec;
  const QuantitySelector({super.key, required this.quantity, required this.onInc, required this.onDec});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _circleIcon(context, Icons.expand_more, onDec),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('$quantity', style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        _circleIcon(context, Icons.expand_less, onInc),
      ],
    );
  }

  Widget _circleIcon(BuildContext context, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: const Color(0xFFF4F5F7), shape: BoxShape.circle),
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class HeartIcon extends StatelessWidget {
  final bool filled;
  final VoidCallback? onTap;
  const HeartIcon({super.key, required this.filled, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(filled ? Icons.favorite : Icons.favorite_border, color: filled ? AppColors.purple : AppColors.textSecondary),
    );
  }
}

class ChipTag extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  const ChipTag({super.key, required this.label, this.selected = false, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.purpleLight : const Color(0xFFF4F5F7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.purple : Colors.transparent),
        ),
        child: Text(label, style: TextStyle(color: selected ? AppColors.purple : AppColors.text)),
      ),
    );
  }
}