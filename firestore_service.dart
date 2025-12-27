import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/favorite_item.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser?.uid ?? '';

  // User Data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }

  // Favorites
  Stream<List<int>> getFavoriteIds() {
    if (uid.isEmpty) return Stream.value([]);
    return _db.collection('users').doc(uid).collection('favorites').snapshots().map((snap) {
      return snap.docs.map((doc) => int.parse(doc.id)).toList();
    });
  }

  Stream<List<FavoriteItem>> favoritesStream() {
    if (uid.isEmpty) return Stream.value([]);
    return _db.collection('users').doc(uid).collection('favorites').snapshots().map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data();
        data['productId'] = data['productId'] ?? int.parse(doc.id);
        return FavoriteItem.fromMap(data);
      }).toList();
    });
  }

  Future<void> toggleFavorite(Product product) async {
    if (uid.isEmpty) return;
    final docRef = _db.collection('users').doc(uid).collection('favorites').doc(product.id.toString());
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        'productId': product.id,
        'title': product.title,
        'price': product.price,
        'image': product.images.isNotEmpty ? product.images.first : '',
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> removeFavorite(int productId) async {
    if (uid.isEmpty) return;
    await _db.collection('users').doc(uid).collection('favorites').doc(productId.toString()).delete();
  }

  // Cart
  Stream<List<CartItem>> cartItemsStream() {
    if (uid.isEmpty) return Stream.value([]);
    return _db.collection('users').doc(uid).collection('cart').snapshots().map((snap) {
      return snap.docs.map((doc) => CartItem.fromMap(doc.data())).toList();
    });
  }

  Future<void> addToCart(Product product, {String size = 'L'}) async {
    if (uid.isEmpty) return;
    final docRef = _db.collection('users').doc(uid).collection('cart').doc(product.id.toString());
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.update({'quantity': FieldValue.increment(1)});
    } else {
      await docRef.set({
        'productId': product.id,
        'title': product.title,
        'price': product.price,
        'image': product.images.isNotEmpty ? product.images.first : '',
        'size': size,
        'quantity': 1,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> updateCartQuantity(int productId, int quantity) async {
    if (uid.isEmpty) return;
    final docRef = _db.collection('users').doc(uid).collection('cart').doc(productId.toString());
    if (quantity <= 0) {
      await docRef.delete();
    } else {
      await docRef.update({'quantity': quantity});
    }
  }

  Future<void> removeCartItem(int productId) async {
    if (uid.isEmpty) return;
    await _db.collection('users').doc(uid).collection('cart').doc(productId.toString()).delete();
  }

  Future<void> clearCart() async {
    if (uid.isEmpty) return;
    final cartRef = _db.collection('users').doc(uid).collection('cart');
    final snap = await cartRef.get();
    final batch = _db.batch();
    for (var doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Stream<int> getCartCount() {
    if (uid.isEmpty) return Stream.value(0);
    return _db.collection('users').doc(uid).collection('cart').snapshots().map((snap) => snap.docs.length);
  }
}
