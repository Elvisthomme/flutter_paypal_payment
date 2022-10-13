import 'package:flutter_paypal_payment/models/models.dart';

/// PayPal transaction information
class Transaction {
  /// Information about the transaction amount
  final Amount amount;

  /// THe description of the transaction
  final String? description;

  /// the Payment options
  final Map<String, String> paymentOptions;

  ///Transaction ItemList
  final ItemList itemList;

  /// Create PayPal transaction information
  Transaction({
    required this.itemList,
    required this.amount,
    this.description,
    this.paymentOptions = const {"allowed_payment_method": "IMMEDIATE_PAY"},
  });

  /// Get the map representation of the transaction
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (description != null) {
      map['description'] = description;
    }

    return {
      ...map,
      'amount': amount.toMap(),
      'payment_options': paymentOptions,
      'item_list': itemList.toMap(),
    };
  }
}
