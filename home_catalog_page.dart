import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme.dart';
import '../services/api.dart';
import '../models/product.dart';
import '../ui/widgets.dart';
import '../services/firestore_service.dart';
import 'product_detail_page.dart';
import 'drawer_menu.dart';
import 'favorites_page.dart';
import 'cart_checkout_page.dart';
import 'profile_page.dart';
import 'wallet_page.dart';

class HomeCatalogPage extends StatefulWidget {
  const HomeCatalogPage({super.key});
  @override
  State<HomeCatalogPage> createState() => _HomeCatalogPageState();
}

class _HomeCatalogPageState extends State<HomeCatalogPage> {
  final _api = ApiService();
  final _fs = FirestoreService();
  final User? user = FirebaseAuth.instance.currentUser;
  late Future<List<Product>> future;
  String query = '';
  final List<String> brands = ['Adidas', 'Nike', 'Fila', 'Puma'];
  int selectedBrand = 1;

  @override
  void initState() {
    super.initState();
    future = _api.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return Container(
            margin: const EdgeInsets.only(left: 12),
            decoration: const BoxDecoration(color: Color(0xFFF4F5F7), shape: BoxShape.circle),
            child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer()),
          );
        }),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(color: Color(0xFFF4F5F7), shape: BoxShape.circle),
            child: IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const ProfilePage()))),
          ),
        ],
        title: Align(
            alignment: Alignment.centerLeft,
            child: FutureBuilder<Map<String, dynamic>?>(
              future: user != null ? _fs.getUserData(user!.uid) : Future.value(null),
              builder: (context, snapshot) {
                final name = snapshot.data?['name'] ?? user?.displayName ?? 'User';
                return Text('Hello, $name', style: const TextStyle(fontWeight: FontWeight.w700));
              },
            )),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(26),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.only(bottom: 8, left: 16),
                  child: Text('Welcome to Laza.',
                      style: TextStyle(color: AppColors.textSecondary)))),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search...'),
                    onChanged: (v) => setState(() => query = v),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(color: AppColors.purple, borderRadius: BorderRadius.circular(16)),
                  child: IconButton(onPressed: () {}, icon: const Icon(Icons.mic, color: Colors.white)),
                ),
              ],
            ),
          ),
          const SectionTitle(title: 'Choose Brand', actionText: 'View All'),
          SizedBox(
            height: 46,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) => ChipTag(
                  label: brands[i],
                  selected: i == selectedBrand,
                  onTap: () => setState(() => selectedBrand = i)),
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemCount: brands.length,
            ),
          ),
          const SectionTitle(title: 'New Arrival', actionText: 'View All'),
          Expanded(
            child: StreamBuilder<List<int>>(
              stream: _fs.getFavoriteIds(),
              builder: (context, favSnap) {
                final favIds = favSnap.data ?? [];
                return FutureBuilder<List<Product>>(
                  future: future,
                  builder: (context, snap) {
                    final products = _api.filterProducts(snap.data ?? [], query);
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (products.isEmpty) {
                      return const Center(child: Text('No products found'));
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.68),
                        itemCount: products.length,
                        itemBuilder: (_, i) {
                          final p = products[i];
                          final isFav = favIds.contains(p.id);
                          final img = p.images.isNotEmpty ? p.images.first : null;
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: p))),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                            child: img != null
                                                ? ClipRRect(
                                                    borderRadius: BorderRadius.circular(15),
                                                    child: Image.network(img, fit: BoxFit.cover))
                                                : const ColoredBox(color: AppColors.divider)),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: HeartIcon(
                                            filled: isFav,
                                            onTap: () => _fs.toggleFavorite(p),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(p.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 6),
                                  Text('\$${p.price.toStringAsFixed(0)}',
                                      style: const TextStyle(fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: AppColors.purple),
              label: 'Home'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), label: 'Bag'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallet'),
        ],
        onDestinationSelected: (i) {
          if (i == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesPage()));
          } else if (i == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CartCheckoutPage()));
          } else if (i == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletPage()));
          }
        },
      ),
    );
  }
}
