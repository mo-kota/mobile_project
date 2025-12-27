import 'package:flutter/material.dart';
import '../models/product.dart';
import '../ui/widgets.dart';
import '../theme.dart';
import '../services/firestore_service.dart';
import 'cart_checkout_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int sizeIndex = 2; // L
  bool readMore = false;
  final fs = FirestoreService();
  final List<String> sizes = ['S', 'M', 'L', 'XL', '2XL'];

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final img = p.images.isNotEmpty ? p.images.first : null;
    return Scaffold(
      appBar: AppBar(
        leading: _circle(const BackButton()),
        actions: [
          _circle(IconButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const CartCheckoutPage())),
            icon: const Icon(Icons.shopping_bag_outlined),
          ))
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (img != null) Image.network(img, height: 360, fit: BoxFit.cover),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24), topRight: Radius.circular(24))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Men's Printed Pullover Hoodie",
                      style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text(p.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  const Text('Price', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text('\$${p.price.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                ]),
              ]),
              const SizedBox(height: 14),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: p.images.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(p.images[i], width: 80, height: 80, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(
                      child: Text('Size',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))),
                  TextButton(
                      onPressed: () {},
                      child: const Text('Size Guide',
                          style: TextStyle(color: AppColors.textSecondary))),
                ],
              ),
              Wrap(
                spacing: 12,
                children: sizes.asMap().entries.map((e) {
                  final selected = sizeIndex == e.key;
                  return ChipTag(
                      label: e.value,
                      selected: selected,
                      onTap: () => setState(() => sizeIndex = e.key));
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Description',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(
                '${p.description}${readMore ? '' : '...'}',
                style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                  onTap: () => setState(() => readMore = !readMore),
                  child: Text(readMore ? 'Read Less' : 'Read More..',
                      style: const TextStyle(fontWeight: FontWeight.w600))),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Expanded(
                      child: Text('Reviews',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))),
                  Text('View All', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const CircleAvatar(radius: 20, backgroundColor: AppColors.divider),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('Ronald Richards')),
                  Row(children: const [
                    Text('4.8 ', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('rating', style: TextStyle(color: AppColors.textSecondary)),
                    SizedBox(width: 6),
                    RatingStars(rating: 4.0)
                  ]),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Total Price', style: TextStyle(fontWeight: FontWeight.w600)),
              const Text('with VAT,SD', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text('\$${p.price.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: PrimaryButton(
        label: 'Add to Cart',
        onPressed: () async {
          await fs.addToCart(p, size: sizes[sizeIndex]);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${p.title} added to cart'),
              action: SnackBarAction(
                label: 'View Cart',
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const CartCheckoutPage())),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _circle(Widget child) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: const BoxDecoration(color: Color(0xFFF4F5F7), shape: BoxShape.circle),
        child: child);
  }
}
