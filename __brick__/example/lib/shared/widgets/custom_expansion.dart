import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import 'custom_expansion_tile.dart';

class CustomExpansion extends StatelessWidget {
  const CustomExpansion({
    Key? key,
    this.expansionCallback,
    required this.children,
  }) : super(key: key);

  final void Function(int, bool)? expansionCallback;
  final List<CustomExpansionTile> children;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: 0.p,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return CustomExpansionTile(
          header: children[index].header,
          body: children[index].body,
          isExpanded: children[index].isExpanded,
          onExpansionChanged: (value) {
            if (expansionCallback != null) {
              expansionCallback!(index, value);
            }
          },
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
    );
  }
}
