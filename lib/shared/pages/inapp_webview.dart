import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppWebView extends StatefulWidget {
  const InAppWebView({super.key});

  static const String routeName = '/web-view';

  @override
  State<InAppWebView> createState() => _InAppWebViewState();
}

class _InAppWebViewState extends State<InAppWebView> {
  WebViewController controller = WebViewController();

  String url = Get.arguments.length != null ? Get.arguments[0] : "";

  RxInt progress = 0.obs;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            this.progress.value = progress;
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onUrlChange: (changedUrl) {
            handleNavigation(changedUrl);
          },
          onNavigationRequest: (NavigationRequest request) {
            print("request.url");
            print(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  Future<void> handleNavigation(UrlChange changedUrl) async {
    String url = changedUrl.url ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            print("canGoBack ${await controller.canGoBack()}");
            if (await controller.canGoBack()) {
              controller.goBack();
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Stack(
            children: [
              Obx(() {
                return SizedBox(
                  height: progress.value != 100 ? 5 : 0,
                  child: LinearProgressIndicator(
                    value: progress.value / 100,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.m2,
                    ),
                  ),
                );
              }),
              WebViewWidget(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}
