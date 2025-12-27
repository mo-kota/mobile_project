import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/api.dart';
import '../models/product.dart';
import '../pages/product_detail_page.dart';

class BrandCatalogPage extends StatefulWidget {
  final String brand;
  const BrandCatalogPage({super.key, required this.brand});
  @override
  State<BrandCatalogPage> createState() => _BrandCatalogPageState();
}

class _BrandCatalogPageState extends State<BrandCatalogPage> {
  final _api = ApiService();
  late Future<List<Product>> future;

  @override
  void initState() {
    super.initState();
    future = _api.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _back(),
        title: SizedBox(
          height: 36,
          child: Container(
            decoration: BoxDecoration(color: const Color(0xFFF4F5F7), borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(child: Text(widget.brand, style: const TextStyle(fontWeight: FontWeight.w600))),
          ),
        ),
        actions: [
          _circle(IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_bag_outlined))),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('365 Items', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                Text('Available in stock', style: TextStyle(color: AppColors.textSecondary)),
              ]),
              OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.sort), label: const Text('Sort')),
            ]),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: future,
              builder: (context, snap) {
                final products = snap.data ?? [];
                if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 0.68),
                    itemCount: products.length,
                    itemBuilder: (_, i) {
                      final p = products[i];
                      final img = p.images.isNotEmpty ? p.images.first : null;
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: p))),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.all(12),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Expanded(child: Stack(children: [
                              Positioned.fill(child: img != null ? Image.network(img, fit: BoxFit.cover) : const ColoredBox(color: AppColors.divider)),
                              const Positioned(top: 8, right: 8, child: Icon(Icons.favorite_border)),
                            ])),
                            const SizedBox(height: 8),
                            Text(p.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 6),
                            Text('\$${p.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                          ]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _back() => Container(margin: const EdgeInsets.only(left: 12), decoration: const BoxDecoration(color: Color(0xFFF4F5F7), shape: BoxShape.circle), child: const BackButton());
  Widget _circle(Widget child) => Container(margin: const EdgeInsets.only(right: 12), decoration: const BoxDecoration(color: Color(0xFFF4F5F7), shape: BoxShape.circle), child: child);
}