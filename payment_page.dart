import 'package:flutter/material.dart';
import '../theme.dart';
import '../ui/widgets.dart';
import 'add_card_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _owner = TextEditingController(text: 'Mrh Raju');
  final _number = TextEditingController(text: '5254 7634 8734 7690');
  final _exp = TextEditingController(text: '24/24');
  final _cvv = TextEditingController(text: '7763');
  bool save = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: _back(), title: const Text('Payment')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _cardMock(),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.purple),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddCardPage())),
            child: const Text('Add new card', style: TextStyle(color: AppColors.purple)),
          ),
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
          const SizedBox(height: 12),
          Row(children: [
            const Expanded(child: Text('Save card info')),
            Switch(value: save, onChanged: (v) => setState(() => save = v), activeColor: AppColors.green),
          ]),
        ],
      ),
      bottomNavigationBar: const PrimaryButton(label: 'Save Card'),
    );
  }

  Widget _labeled(String label, TextEditingController c) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      TextField(controller: c),
    ]);
  }

  Widget _cardMock() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [Color(0xFFFFC84A), Color(0xFFFF6A63)], begin: Alignment.centerLeft, end: Alignment.centerRight),
      ),
      padding: const EdgeInsets.all(20),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Mrh Raju', style: TextStyle(color: Colors.white, fontSize: 18)),
        Spacer(),
        Text('Visa Classic', style: TextStyle(color: Colors.white70)),
        SizedBox(height: 8),
        Text('5254 **** **** 7690', style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 1.4)),
        SizedBox(height: 8),
        Text('\$3,763.87', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _back() => Container(margin: const EdgeInsets.only(left: 12), decoration: const BoxDecoration(color: Color(0xFFF4F5F7), shape: BoxShape.circle), child: const BackButton());
}