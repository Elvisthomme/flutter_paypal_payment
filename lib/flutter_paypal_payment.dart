// ignore_for_file: constant_identifier_names

library flutter_paypal_payment;

import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/pages/complete_payment.dart';
import 'package:flutter_paypal_payment/services/paypal_service.dart';
import 'package:flutter_paypal_payment/widgets/network_error.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'models/transaction.dart';

class PayPalWebView extends StatefulWidget {
  /// Success payment call back function
  ///
  /// Take the [PayPalPaymentDetail] as argument
  final Function(PayPalPaymentDetail) onSuccess;

  /// The builder return the widget to display on network error
  final Widget Function(void reload)? netWorkErrorWidgetBuilder;

  /// Error call back function
  ///
  /// Take a map containing the error message as argument
  final Function(Map<String, dynamic> errorData) onError;

  final Future<bool> Function()? onWillPop;

  /// The widget displayed on loading
  final Widget? loadingIndicatorWidget;

  /// A builder that return an app bar to display at the top of the scaffold.
  final PreferredSizeWidget? Function(bool isPageLoading)? appBar;

  final Function onCancel;
  final String returnURL, cancelURL, note, clientId, secretKey;

  /// The list of transaction as [dynamic]
  ///
  /// If [transactions] is not null it is ignore
  ///
  /// But both can't be null
  final List? transactionsMap;

  /// The list of transaction as [Transaction] object
  ///
  /// If it is define at the same time as [transactionsMap]
  /// [transactionsMap] is ignore
  ///
  /// But both can't be null
  final List<Transaction>? transactions;
  final bool sandboxMode;
  const PayPalWebView({
    Key? key,
    required this.onSuccess,
    required this.onError,
    required this.onCancel,
    required this.returnURL,
    required this.cancelURL,
    this.transactionsMap,
    required this.clientId,
    required this.secretKey,
    this.sandboxMode = false,
    this.note = '',
    this.onWillPop,
    this.appBar,
    this.loadingIndicatorWidget,
    this.netWorkErrorWidgetBuilder,
    this.transactions,
  })  : assert(transactions != null || transactionsMap != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PayPalWebViewState();
  }
}

class PayPalWebViewState extends State<PayPalWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  String checkoutUrl = '';
  String navUrl = '';
  String executeUrl = '';
  String accessToken = '';
  bool loading = true;
  bool isPageLoading = true;
  bool loadingError = false;
  late PayPalServices services;
  int pressed = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.onWillPop ??
          () async {
            if (pressed < 2) {
              setState(() {
                pressed++;
              });
              final snackBar = SnackBar(
                  content: Text(
                      'Press back ${3 - pressed} more times to cancel transaction'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return false;
            } else {
              return true;
            }
          },
      child: Scaffold(
          appBar: widget.appBar != null
              ? widget.appBar!(isPageLoading)
              : AppBar(
                  backgroundColor:
                      Theme.of(context).appBarTheme.backgroundColor ??
                          const Color(0xFF272727),
                  leading: GestureDetector(
                    child: const Icon(Icons.arrow_back_ios),
                    onTap: () => Navigator.pop(context),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              color: Uri.parse(navUrl).hasScheme
                                  ? Colors.green
                                  : Colors.blue,
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                navUrl,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            SizedBox(width: isPageLoading ? 5 : 0),
                            isPageLoading
                                ? widget.loadingIndicatorWidget ??
                                    const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    )
                                : const SizedBox()
                          ],
                        ),
                      ))
                    ],
                  ),
                  elevation: 0,
                ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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
                                  ? widget
                                      .netWorkErrorWidgetBuilder!(loadPayment)
                                  : NetworkErrorDefaultWidget(
                                      loadData: loadPayment,
                                      message: "Something went wrong,"),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: WebView(
                              initialUrl: checkoutUrl,
                              javascriptMode: JavascriptMode.unrestricted,
                              gestureNavigationEnabled: true,
                              onWebViewCreated:
                                  (WebViewController webViewController) {
                                _controller.complete(webViewController);
                              },
                              javascriptChannels: <JavascriptChannel>{
                                _toasterJavascriptChannel(context),
                              },
                              navigationDelegate:
                                  (NavigationRequest request) async {
                                if (request.url
                                    .startsWith('https://www.youtube.com/')) {
                                  return NavigationDecision.prevent;
                                }
                                if (request.url.contains(widget.returnURL)) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CompletePayment(
                                            url: request.url,
                                            services: services,
                                            executeUrl: executeUrl,
                                            accessToken: accessToken,
                                            onSuccess: widget.onSuccess,
                                            onError: widget.onError)),
                                  );
                                }
                                if (request.url.contains(widget.cancelURL)) {
                                  final uri = Uri.parse(request.url);
                                  await widget.onCancel(uri.queryParameters);
                                  Navigator.of(context).pop();
                                }
                                return NavigationDecision.navigate;
                              },
                              onPageStarted: (String url) {
                                setState(() {
                                  isPageLoading = true;
                                  loadingError = false;
                                });
                              },
                              onPageFinished: (String url) {
                                setState(() {
                                  navUrl = url;
                                  isPageLoading = false;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
          )),
    );
  }

  Map getOrderParams() {
    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": widget.transactions?.map((e) => e.toMap()).toList() ??
          widget.transactionsMap,
      "note_to_payer": widget.note,
      "redirect_urls": {
        "return_url": widget.returnURL,
        "cancel_url": widget.cancelURL
      }
    };
    return temp;
  }

  @override
  void initState() {
    super.initState();
    services = PayPalServices(
      sandboxMode: widget.sandboxMode,
      clientId: widget.clientId,
      secretKey: widget.secretKey,
    );
    setState(() {
      navUrl = widget.sandboxMode
          ? 'https://api.sandbox.paypal.com'
          : 'https://www.api.paypal.com';
    });
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    loadPayment();
  }

  loadPayment() async {
    setState(() {
      loading = true;
    });
    try {
      Map getToken = await services.getAccessToken();
      if (getToken['token'] != null) {
        accessToken = getToken['token'];
        final transactions = getOrderParams();
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        if (res["approvalUrl"] != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"].toString();
            navUrl = res["approvalUrl"].toString();
            executeUrl = res["executeUrl"].toString();
            loading = false;
            isPageLoading = false;
            loadingError = false;
          });
        } else {
          widget.onError(res);
          setState(() {
            loading = false;
            isPageLoading = false;
            loadingError = true;
          });
        }
      } else {
        widget.onError({'message': "${getToken['message']}"});

        setState(() {
          loading = false;
          isPageLoading = false;
          loadingError = true;
        });
      }
    } catch (e) {
      widget.onError({'message': e.toString()});
      setState(() {
        loading = false;
        isPageLoading = false;
        loadingError = true;
      });
    }
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          widget.onError({'message': message.message});
        });
  }
}
