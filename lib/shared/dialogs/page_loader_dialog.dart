import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> showPageLoader(
  BuildContext context, {
  bool barrierDismissible = true,
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    useRootNavigator: false,
    builder: (_) => PageLoader(barrierDismissible: barrierDismissible),
  );
}

class PageLoader extends StatelessWidget {
  const PageLoader({Key? key, required this.barrierDismissible})
    : super(key: key);

  final bool barrierDismissible;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (barrierDismissible) {
          Get.back();
        }
        return Future.value(false);
      },
      child: const SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
