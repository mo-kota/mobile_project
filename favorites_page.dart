import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/firestore_service.dart';
import '../models/favorite_item.dart';
import 'cart_checkout_page.dart';
import 'home_catalog_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fs = FirestoreService();
    return Scaffold(
      appBar: AppBar(
        leading: _back(),
        title: const Text('Wishlist'),
        actions: [
          _circle(IconButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const CartCheckoutPage())),
            icon: const Icon(Icons.shopping_bag_outlined),
          )),
        ],
      ),
      body: StreamBuilder<List<FavoriteItem>>(
        stream: fs.favoritesStream(),
        builder: (context, snap) {
          final items = snap.data ?? [];
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${items.length} Items',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                        const Text('in wishlist', style: TextStyle(color: AppColors.textSecondary)),
                      ],
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text('No favorites yet'))
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.68,
                          ),
                          itemCount: items.length,
                          itemBuilder: (_, i) {
                            final item = items[i];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: Image.network(item.image, fit: BoxFit.cover),
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () => fs.removeFavorite(item.productId),
                                            child: const Icon(Icons.favorite, color: AppColors.purple),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 6),
                                  Text('\$${item.price.toStringAsFixed(0)}',
                                      style: const TextStyle(fontWeight: FontWeight.w700)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (i) {
          if (i == 0) {
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (_) => const HomeCatalogPage()), (_) => false);
          } else if (i == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CartCheckoutPage()));
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Wishlist'),
          NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), label: 'Bag'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallet'),
        ],
      ),
    );
  }

  Widget _back() => Container(
        margin: const EdgeInsets.only(left: 12),
        decoration: const BoxDecoration(color: Color(0xFFF4F5F7), shape: BoxShape.circle),
        child: const BackButton(),
      );

  Widget _circle(Widget child) => Container(
        margin: const EdgeInsets.only(right: 12),
        decoration: const BoxDecoration(color: Color(0xFFF4F5F7), shape: BoxShape.circle),
        child: child,
      );
}
