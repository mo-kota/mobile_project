import 'package:flutter/material.dart';
import '../theme.dart';
import '../ui/widgets.dart';
import '../models/cart_item.dart';
import 'home_catalog_page.dart';

class OrderConfirmedPage extends StatelessWidget {
  final List<CartItem> items;
  const OrderConfirmedPage({super.key, this.items = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: _back(context)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.check_circle_outline, size: 100, color: AppColors.green),
            const SizedBox(height: 20),
            const Text(
              'Order Confirmed!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your order has been confirmed, we will send you confirmation email shortly.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            if (items.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Order Summary',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(item.image,
                                width: 50, height: 50, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Text('${item.quantity} x \$${item.price.toStringAsFixed(0)}',
                                    style: const TextStyle(color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          Text('\$${(item.price * item.quantity).toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.w700)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ] else
              const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4F5F7),
                  foregroundColor: AppColors.text,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {
                  // TODO: Navigate to Orders list page
                },
                child: const Text('Go to Orders'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PrimaryButton(
        label: 'Continue Shopping',
        onPressed: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeCatalogPage()),
          (_) => false,
        ),
      ),
    );
  }

  Widget _back(BuildContext context) => Container(
        margin: const EdgeInsets.only(left: 12),
        decoration: const BoxDecoration(
          color: Color(0xFFF4F5F7),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      );
}
