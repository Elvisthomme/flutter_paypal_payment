import 'article.dart';
import 'shipping_address.dart';

/// PayPal payment item list
class ItemList {
  //The shipping address information
  final ShippingAddress? shippingAddress;

  /// The list of article to pay
  final List<Article> items;

  /// Create PapPal payment item list
  ItemList({this.shippingAddress, required this.items})
      : assert(items.isNotEmpty, 'The item list must be field');

  /// Get the map representation of [ItemList]
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (shippingAddress != null) {
      map['shipping_address'] = shippingAddress!.toMap();
    }
    map['item_list'] = items.map((e) => e.toMap()).toList();
    return map;
  }
}
