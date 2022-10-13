import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PayPal Payment Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter PayPal Payment Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: TextButton(
              onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => PayPalWebView(
                            sandboxMode: true,
                            clientId:
                                "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0",
                            secretKey:
                                "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9",
                            returnURL: "https://samplesite.com/return",
                            cancelURL: "https://samplesite.com/cancel",
                            transactions: [
                              {
                                "amount": {
                                  "currency": "BRL",
                                  "total": "93.00",
                                  "details": {
                                    "shipping": "11",
                                    "subtotal": "75",
                                    "shipping_discount": "1.00",
                                    "insurance": "1.00",
                                    "handling_fee": "1.00",
                                    "tax": "6.00"
                                  }
                                },
                                "description":
                                    "This is the payment transaction description",
                                "payment_options": {
                                  "allowed_payment_method": "IMMEDIATE_PAY"
                                },
                                "item_list": {
                                  "shipping_address": {
                                    "recipient_name": "PP Plus Recipient",
                                    "line1": "Gregório Rolim de Oliveira, 42",
                                    "line2": "JD Serrano II",
                                    "city": "Votorantim",
                                    "country_code": "BR",
                                    "postal_code": "18117-134",
                                    "state": "São Paulo",
                                    "phone": "0800-761-0880"
                                  },
                                  "items": [
                                    {
                                      "name": "handbag",
                                      "description": "red diamond",
                                      "quantity": "1",
                                      "price": "75",
                                      "tax": "6",
                                      "sku": "product34",
                                      "currency": "BRL"
                                    }
                                  ]
                                }
                              }
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (params) async {
                              print("onSuccess: $params");
                            },
                            onError: (error) {
                              print("onError: $error");
                            },
                            onCancel: (params) {
                              print('cancelled: $params');
                            }),
                      ),
                    )
                  },
              child: const Text("Make Payment")),
        ));
  }
}
