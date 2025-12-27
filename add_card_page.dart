import 'package:flutter/material.dart';
import '../theme.dart';
import '../ui/widgets.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});
  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final _owner = TextEditingController(text: 'Mrh Raju');
  final _number = TextEditingController(text: '5254 7634 8734 7690');
  final _exp = TextEditingController(text: '24/24');
  final _cvv = TextEditingController(text: '7763');
  int methodIndex = 0; // 0=Mastercard, 1=PayPal, 2=Bank

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: _back(), title: const Text('Add New Card')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(children: [
              Expanded(child: _methodChip('Mastercard', selected: methodIndex == 0, onTap: () => setState(() => methodIndex = 0))),
              const SizedBox(width: 12),
              Expanded(child: _methodChip('PayPal', selected: methodIndex == 1, onTap: () => setState(() => methodIndex = 1))),
              const SizedBox(width: 12),
              Expanded(child: _methodChip('Bank', selected: methodIndex == 2, onTap: () => setState(() => methodIndex = 2))),
            ]),
            const SizedBox(height: 16),
            _labeled('Card Owner', _owner),
            const SizedBox(height: 12),
            _labeled('Card Number', _number),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _labeled('EXP', _exp)),
              const SizedBox(width: 12),
              Expanded(child: _labeled('CVV', _cvv)),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: const PrimaryButton(label: 'Add Card'),
    );
  }

  Widget _methodChip(String label, {required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF1E6) : const Color(0xFFF4F5F7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.orange : Colors.transparent),
        ),
        child: Center(child: Text(label)),
      ),
    );
  }

  Widget _labeled(String label, TextEditingController c) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      TextField(controller: c),
    ]);
  }

  Widget _back() => Container(margin: const EdgeInsets.only(left: 12), decoration: const BoxDecoration(color: Color(0xFFF4F5F7), shape: BoxShape.circle), child: const BackButton());
}