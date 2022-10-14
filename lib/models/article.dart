
/// PayPal transaction article
class Article {
  /// article's name
  final String name;

  ///article's description
  final String description;

  /// The number of articles
  final int quantity;

  /// The price of one article
  final double price;

  /// The article tax fee
  final double? tax;

  /// The article sku
  final String? sku;

  /// Create PayPal transaction article
  Article({
    required this.name,
    this.description = '',
    this.quantity = 1,
    required this.price,
    this.tax,
    this.sku,
  });

  /// Get the map representation of the [Article]
  Map<String, String> toMap() {
    Map<String, String> map = {};
    if (tax != null) {
      map['tax'] = tax.toString();
    }
    if (sku != null) {
      map['sku'] = sku!;
    }
    return {
      ...map,
      'name': name,
      'description': description,
      'quantity': quantity.toString(),
      'price': price.toString(),
      'tax': tax.toString(),
    };
  }
}
