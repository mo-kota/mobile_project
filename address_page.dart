import 'package:flutter/material.dart';
import '../theme.dart';
import '../ui/widgets.dart';
import '../models/cart_item.dart';
import '../services/firestore_service.dart';
import 'order_confirmed_page.dart';

class AddressPage extends StatefulWidget {
  final List<CartItem> items;
  const AddressPage({super.key, this.items = const []});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final _name = TextEditingController(text: 'Mrh Raju');
  final _country = TextEditingController(text: 'Bangladesh');
  final _city = TextEditingController(text: 'Sylhet');
  final _phone = TextEditingController(text: '+880 1453-987533');
  final _address = TextEditingController(text: 'Chhatak, Sunamgonj 12/8AB');
  bool primary = true;
  final _fs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: _back(), title: const Text('Address')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _labeled('Name', _name),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _labeled('Country', _country)),
                const SizedBox(width: 12),
                Expanded(child: _labeled('City', _city)),
              ]),
              const SizedBox(height: 12),
              _labeled('Phone Number', _phone),
              const SizedBox(height: 12),
              _labeled('Address', _address),
              const SizedBox(height: 12),
              Row(children: [
                const Expanded(child: Text('Save as primary address')),
                Switch(
                  value: primary,
                  onChanged: (v) => setState(() => primary = v),
                  activeThumbColor: AppColors.green,
                ),
              ]),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PrimaryButton(
        label: 'Save Address',
        onPressed: () async {
          // Clear the cart when the order is "placed"
          await _fs.clearCart();
          
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => OrderConfirmedPage(items: widget.items),
            ),
            (route) => route.isFirst,
          );
        },
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

  Widget _back() => Container(
        margin: const EdgeInsets.only(left: 12),
        decoration: const BoxDecoration(color: Color(0xFFF4F5F7), shape: BoxShape.circle),
        child: const BackButton(),
      );
}
