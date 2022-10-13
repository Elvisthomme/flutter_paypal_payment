import 'package:flutter/material.dart';

///Default displayed widget on network error
class NetworkErrorDefaultWidget extends StatelessWidget {
  final Function loadData;
  final String message;
  final bool isSmall;

  const NetworkErrorDefaultWidget({
    Key? key,
    required this.loadData,
    required this.message,
    this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_off,
            size: 120,
          ),
          SizedBox(
            height: isSmall ? 20 : 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF272727),
                      fontWeight: FontWeight.w400)),
              const SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () => loadData(),
                child: const Text("Tap to retry",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
