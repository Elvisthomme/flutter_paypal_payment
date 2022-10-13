/// PayPAL shipping address
class ShippingAddress {
  /// The recipient's name
  final String recipientName;

  /// The first line address
  final String line1;

  /// The second line address
  final String? line2;

  /// The city address
  final String city;

  /// The country code
  final String? countryCode;

  /// The postalCode
  final String? postalCode;

  /// The address state
  final String? state;

  /// The recipient phone number
  final String phone;

  /// Create PayPAL shipping address
  ShippingAddress({
    required this.recipientName,
    required this.line1,
    this.line2,
    required this.city,
    this.countryCode,
    this.postalCode,
    this.state,
    required this.phone,
  });

  /// Get the map representation of the shipping address
  Map<String, String> toMap() {
    Map<String, String> map = {};

    if (line2 != null) {
      map['line2'] = line2.toString();
    }
    if (countryCode != null) {
      map['country_code'] = countryCode.toString();
    }
    if (postalCode != null) {
      map['postal_code'] = postalCode.toString();
    }
    if (state != null) {
      map['state'] = state.toString();
    }
    return {
      ...map,
      'recipient_name': recipientName,
      'line1': line1,
      'city': city,
      'phone': phone,
    };
  }
}
