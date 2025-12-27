import 'package:flutter/material.dart';
import '../theme.dart';
import '../ui/widgets.dart';
import '../services/firestore_service.dart';
import '../models/cart_item.dart';
import 'address_page.dart';
import 'payment_page.dart';

class CartCheckoutPage extends StatelessWidget {
  const CartCheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fs = FirestoreService();

    return Scaffold(
      appBar: AppBar(leading: _back(), title: const Text('Cart')),
      body: StreamBuilder<List<CartItem>>(
        stream: fs.cartItemsStream(),
        builder: (context, snap) {
          final items = snap.data ?? [];
          final subtotal = items.fold<double>(0, (s, i) => s + i.price * i.quantity);
          const shipping = 10.0;
          final total = subtotal + shipping;

          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (items.isEmpty) return const Center(child: Text('Your cart is empty'));

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ...items.map((i) => _cartRow(context, i, fs)),
              const SizedBox(height: 12),
              _sectionHeader(context, 'Delivery Address', trailing: _chev(() => Navigator.push(context, MaterialPageRoute(builder: (_) => AddressPage(items: items)))), ok: true),
              ListTile(
                leading: ClipRRect(borderRadius: BorderRadius.circular(12), child: Container(color: AppColors.divider, width: 48, height: 48)),
                title: const Text('Chhatak, Sunamgonj 12/8AB'),
                subtitle: const Text('Sylhet', style: TextStyle(color: AppColors.textSecondary)),
                trailing: const Icon(Icons.check_circle, color: AppColors.green),
              ),
              const SizedBox(height: 8),
              _sectionHeader(context, 'Payment Method', trailing: _chev(() => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentPage()))), ok: true),
              ListTile(
                leading: ClipRRect(borderRadius: BorderRadius.circular(12), child: Container(color: AppColors.divider, width: 48, height: 32, child: const Center(child: Text('VISA')))),
                title: const Text('Visa Classic'),
                subtitle: const Text('**** 7690', style: TextStyle(color: AppColors.textSecondary)),
                trailing: const Icon(Icons.check_circle, color: AppColors.green),
              ),
              const SizedBox(height: 12),
              const Text('Order Info', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 8),
              _priceRow('Subtotal', subtotal),
              _priceRow('Shipping cost', shipping),
              const Divider(),
              _priceRow('Total', total, bold: true),
            ],
          );
        },
      ),
      bottomNavigationBar: StreamBuilder<List<CartItem>>(
        stream: fs.cartItemsStream(),
        builder: (context, snap) {
          final items = snap.data ?? [];
          return PrimaryButton(
            label: 'Checkout',
            onPressed: items.isEmpty ? null : () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddressPage(items: items)),
            ),
          );
        }
      ),
    );
  }

  Widget _cartRow(BuildContext context, CartItem item, FirestoreService fs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(item.image, width: 72, height: 72, fit: BoxFit.cover)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.title, maxLines: 2),
            Text('\$${item.price.toStringAsFixed(0)} (-\$4.00 Tax)', style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            QuantitySelector(quantity: item.quantity, onInc: () => fs.updateCartQuantity(item.productId, item.quantity + 1), onDec: () => fs.updateCartQuantity(item.productId, item.quantity - 1)),
          ])),
          IconButton(onPressed: () => fs.removeCartItem(item.productId), icon: const Icon(Icons.delete_outline)),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title, {Widget? trailing, bool ok = false}) {
    return Row(children: [
      Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
      if (trailing != null) trailing,
      const SizedBox(width: 8),
      if (ok) const Icon(Icons.check_circle, color: AppColors.green),
    ]);
  }

  Widget _chev(VoidCallback onTap) => IconButton(onPressed: onTap, icon: const Icon(Icons.chevron_right));
  Widget _priceRow(String label, double price, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(color: AppColors.textSecondary, fontWeight: bold ? FontWeight.w600 : FontWeight.w400)),
        Text('\$${price.toStringAsFixed(0)}', style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
      ]),
    );
  }

  Widget _back() => Container(margin: const EdgeInsets.only(left: 12), decoration: const BoxDecoration(color: Color(0xFFF4F5F7), shape: BoxShape.circle), child: const BackButton());
}
