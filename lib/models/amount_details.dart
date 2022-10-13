/// Amount details for the transaction
class AmountDetails {
  /// The shipping fee
  final double? shipping;

  /// The subtotal of the transaction item
  final double? subtotal;

  // The shipping discount
  final double? shippingDiscount;

  /// The insurance fee
  final double? insurance;

  /// The handling fee
  final double? handlingFee;

  /// The tax fee
  final double? tax;

  const AmountDetails({
    this.shipping,
    this.subtotal,
    this.shippingDiscount,
    this.insurance,
    this.handlingFee,
    this.tax,
  });

  /// Get the map representation of the amount detail
  Map<String, String> toMap() {
    Map<String, String> map = {};
    if (shipping != null) {
      map['shipping'] = shipping.toString();
    }
    if (subtotal != null) {
      map['subtotal'] = subtotal.toString();
    }
    if (shippingDiscount != null) {
      map['shipping_discount'] = shippingDiscount.toString();
    }
    if (insurance != null) {
      map['insurance'] = insurance.toString();
    }
    if (handlingFee != null) {
      map['handling_fee'] = handlingFee.toString();
    }
    if (tax != null) {
      map['tax'] = tax.toString();
    }
    return map;
  }
}
