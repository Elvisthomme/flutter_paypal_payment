import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/widgets/network_error.dart';
import 'package:flutter_paypal_payment/services/paypal_service.dart';

/// Finalize and initiated payment
class CompletePayment extends StatefulWidget {
  /// Error call back function
  ///
  /// Take a map containing the error message as argument
  final Function(Map<String, dynamic> errorData) onError;

  /// Success payment call back function
  ///
  /// Take the [PayPalPaymentDetail] as argument
  final Function(PayPalPaymentDetail) onSuccess;

  /// The [PayPalServices] use for request
  final PayPalServices services;

  final String url, executeUrl, accessToken;

  /// The widget displayed on loading
  final Widget? loadingIndicatorWidget;

  /// The widget displayed on loading
  final Widget? successWidget;

  /// The builder return the widget to display on network error
  final Widget Function(void reload)? netWorkErrorWidgetBuilder;

  const CompletePayment({
    Key? key,
    required this.onSuccess,
    required this.onError,
    required this.services,
    required this.url,
    required this.executeUrl,
    required this.accessToken,
    this.loadingIndicatorWidget,
    this.netWorkErrorWidgetBuilder,
    this.successWidget,
  }) : super(key: key);

  @override
  _CompletePaymentState createState() => _CompletePaymentState();
}

/// Model managing paypal payment detail
class PayPalPaymentDetail {
  final String payerID;
  final String paymentId;
  final String token;
  String? status;
  Map<String, dynamic>? data;

  PayPalPaymentDetail(
      {required this.payerID, required this.paymentId, required this.token});
}

class _CompletePaymentState extends State<CompletePayment> {
  bool loading = true;
  bool loadingError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: loading
            ? Column(
                children: [
                  Expanded(
                    child: Center(
                        child: widget.loadingIndicatorWidget ??
                            const CircularProgressIndicator()),
                  ),
                ],
              )
            : loadingError
                ? Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: widget.netWorkErrorWidgetBuilder != null
                              ? widget.netWorkErrorWidgetBuilder!(complete)
                              : NetworkErrorDefaultWidget(
                                  loadData: complete,
                                  message: "Something went wrong,"),
                        ),
                      ),
                    ],
                  )
                : widget.successWidget ??
                    const Center(
                      child: Text("Payment Completed"),
                    ),
      ),
    );
  }

  void complete() async {
    final uri = Uri.parse(widget.url);
    final payerID = uri.queryParameters['PayerID'];
    if (payerID != null) {
      final params = PayPalPaymentDetail(
          payerID: payerID.toString(),
          paymentId: uri.queryParameters['paymentId'].toString(),
          token: uri.queryParameters['token'].toString());
      setState(() {
        loading = true;
        loadingError = false;
      });

      Map<String, dynamic> resp = await widget.services
          .executePayment(widget.executeUrl, payerID, widget.accessToken);
      if (resp['error'] == false) {
        params.status = 'success';
        params.data = resp['data'];
        await widget.onSuccess(params);
        setState(() {
          loading = false;
          loadingError = false;
        });
        Navigator.pop(context);
      } else {
        if (resp['exception'] != null && resp['exception'] == true) {
          widget.onError({"message": resp['message']});
          setState(() {
            loading = false;
            loadingError = true;
          });
        } else {
          await widget.onError(resp['data']);
          Navigator.of(context).pop();
        }
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    complete();
  }
}
