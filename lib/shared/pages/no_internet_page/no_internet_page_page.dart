import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import '../../buttons/main_button.dart';

class NoInternetPage extends StatelessWidget {
  static const String routeName = "/no-internet";
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.signal_wifi_off,
              size: 100,
              color: Colors.red.withValues(alpha: 0.8),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MainButton(
                color: Colors.red.withValues(alpha: 0.7),
                title: 'Retry',
                onTap: () async {
                  await Stac.onCallFromJson(
                    StacNavigator.pushAndRemoveAllStac('splash_page').toJson(),
                    context,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
