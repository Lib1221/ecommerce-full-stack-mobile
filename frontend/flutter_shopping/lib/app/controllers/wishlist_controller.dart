import 'package:get/get.dart';

class WishlistController extends GetxController {
  var favorites = <int>{}.obs;

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
