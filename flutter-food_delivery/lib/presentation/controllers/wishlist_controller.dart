import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WishlistController extends GetxController {
  var favorites = <int>{}.obs;
  final box = GetStorage();
  final _key = 'wishlist';

  @override
  void onInit() {
    super.onInit();
    final stored = box.read(_key);
    if (stored != null && stored is List) {
      favorites.addAll(stored.cast<int>());
    }
    ever(favorites, (Set<int> favs) {
      box.write(_key, favs.toList());
    });
  }

  void addToWishlist(int productId) {
    favorites.add(productId);
  }

  void removeFromWishlist(int productId) {
    favorites.remove(productId);
  }

  bool isFavorite(int productId) {
    return favorites.contains(productId);
  }
}
