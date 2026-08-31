import 'package:stac/stac_core.dart';

@StacScreen(screenName: "hello_world")
StacWidget helloWorld() {
  return StacScaffold(
    backgroundColor: StacColors.white,
    body: StacCenter(child: StacText(data: 'Hello World')),
  );
}
