import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import 'wildcard_page.dart';

class WildcardPageParser extends StacParser<WildcardPage> {
  @override
  String get type => 'st_wildcard_page';

  @override
  WildcardPage getModel(Map<String, dynamic> json) =>
      WildcardPage.fromJson(json);

  @override
  Widget parse(BuildContext context, WildcardPage model) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg != null &&
        arg is Map<String, dynamic> &&
        arg.containsKey('wildcardPage')) {
      return model.children[arg['wildcardPage']]?.parse(context) ??
          const Center(child: Text('Unknown wildcard page'));
    }
    return const Center(child: Text('No wildcard page was selected'));
  }
}
