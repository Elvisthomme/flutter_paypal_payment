import 'package:flutter_paypal_payment/models/models.dart';

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

  /// The article price currency
  final Currency currency;

  /// Create PayPal transaction article
  Article({
    required this.name,
    this.description = '',
    this.quantity = 1,
    required this.price,
    this.tax,
    this.sku,
    this.currency = Currency.EUR,
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
      'currency': currency.toString().split('.').last,
    };
  }
}
