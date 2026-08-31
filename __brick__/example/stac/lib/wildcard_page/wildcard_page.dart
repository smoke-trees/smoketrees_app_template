import 'package:{{project_name}}/stac_runtime/widgets/layout/wildcard_page/wildcard_page.dart';
import 'package:stac/stac_core.dart';

import 'pages/page1.dart';
import 'pages/page2.dart';

@StacScreen(screenName: "wildcard_page")
StacWidget wildcardPage() =>
    WildcardPage(children: {'page1': page1(), 'page2': page2()});
