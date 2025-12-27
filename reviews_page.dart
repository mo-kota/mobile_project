import 'package:flutter/material.dart';
import '../theme.dart';
import '../ui/widgets.dart';
import 'add_review_page.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = List.generate(4, (i) => {
      'name': ['Jenny Wilson', 'Ronald Richards', 'Guy Hawkins', 'Savannah Nguyen'][i],
      'date': '13 Sep, 2020',
      'rating': 4.8,
      'text': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet...',
    });

    return Scaffold(
      appBar: AppBar(
        leading: _back(),
        title: const Text('Reviews'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddReviewPage())),
              child: const Text('Add Review'),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemCount: reviews.length,
        itemBuilder: (_, i) {
          final r = reviews[i];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const CircleAvatar(radius: 22, backgroundColor: AppColors.divider),
                const SizedBox(width: 12),
                Expanded(child: Text(r['name'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                Row(children: [Text('${r['rating']}', style: const TextStyle(fontWeight: FontWeight.w600)), const SizedBox(width: 4), const Text('rating', style: TextStyle(color: AppColors.textSecondary))]),
              ]),
              const SizedBox(height: 6),
              Row(children: [const Icon(Icons.schedule, size: 16, color: AppColors.textSecondary), const SizedBox(width: 4), Text(r['date'] as String, style: const TextStyle(color: AppColors.textSecondary))]),
              const SizedBox(height: 12),
              Text(r['text'] as String, style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
              const SizedBox(height: 8),
              const RatingStars(rating: 4.0),
            ],
          );
        },
      ),
    );
  }

  Widget _back() => Container(margin: const EdgeInsets.only(left: 12), decoration: const BoxDecoration(color: Color(0xFFF4F5F7), shape: BoxShape.circle), child: const BackButton());
}