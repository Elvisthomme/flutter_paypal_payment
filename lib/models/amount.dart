import 'amount_details.dart';
import 'currency.dart';

/// The amount of the transaction
class Amount {
  /// Transaction currency
  final Currency currency;

  /// The total amount of the transaction
  final double total;

  /// The Transaction detail
  final AmountDetails? details;
/// Create The amount of the transaction
  const Amount({
    this.details,
    required this.total,
    this.currency = Currency.EUR,
  });

  /// Get the map representation of the amount detail
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    map['currency'] = currency.toString().split('.').last;
    map['total'] = total;
    if (details != null) {
      map['details'] = details!.toMap();
    }

    return map;
  }
}
