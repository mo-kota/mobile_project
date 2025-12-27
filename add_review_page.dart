import 'package:flutter/material.dart';
import '../theme.dart';
import '../ui/widgets.dart';

class AddReviewPage extends StatefulWidget {
  const AddReviewPage({super.key});
  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final _name = TextEditingController();
  final _text = TextEditingController();
  double stars = 2.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: _back(), title: const Text('Add Review')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _labeledField('Name', _name, hint: 'Type your name'),
            const SizedBox(height: 16),
            _labeledArea('How was your experience ?', _text, hint: 'Describe your experience?'),
            const SizedBox(height: 16),
            const Align(alignment: Alignment.centerLeft, child: Text('Star', style: TextStyle(fontWeight: FontWeight.w600))),
            Slider(min: 0.0, max: 5.0, divisions: 50, value: stars, onChanged: (v) => setState(() => stars = v), activeColor: AppColors.purple),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: const PrimaryButton(label: 'Submit Review'),
    );
  }

  Widget _labeledField(String label, TextEditingController c, {String? hint}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      TextField(controller: c, decoration: InputDecoration(hintText: hint)),
    ]);
  }

  Widget _labeledArea(String label, TextEditingController c, {String? hint}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      SizedBox(height: 160, child: TextField(controller: c, maxLines: null, expands: true, textAlignVertical: TextAlignVertical.top, decoration: InputDecoration(hintText: hint))),
    ]);
  }

  Widget _back() => Container(margin: const EdgeInsets.only(left: 12), decoration: const BoxDecoration(color: Color(0xFFF4F5F7), shape: BoxShape.circle), child: const BackButton());
}