import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:{{project_name}}/theme/colors.dart';

import '../dialogs/show_image_dialog.dart';

class HtmlText extends StatelessWidget {
  const HtmlText({
    Key? key,
    required this.text,
    this.style,
    this.showCustomStyle = true,
  }) : super(key: key);

  final String text;
  final Map<String, Style>? style;

  final bool showCustomStyle;

  @override
  Widget build(BuildContext context) {
    if (!showCustomStyle) {
      return SelectionArea(
        child: Html(
          data: text,
          shrinkWrap: true,
          extensions: [
            OnImageTapExtension(
              onImageTap: (src, imgAttributes, element) {
                if (src != null) {
                  showImageDialog(context, src);
                }
              },
            ),
          ],
          onAnchorTap: (url, item, element) {
            print("url $url");
          },
        ),
      );
    } else {
      return SelectionArea(
        child: Html(
          data: text,
          shrinkWrap: true,
          onAnchorTap: (url, item, element) {
            print("url $url");
          },
          extensions: [
            OnImageTapExtension(
              onImageTap: (src, imgAttributes, element) {
                if (src != null) {
                  showImageDialog(context, src);
                }
              },
            ),
          ],
          style:
              style ??
              {
                "*": Style(color: AppColors.grey1),
                "ol": Style(
                  margin: Margins.all(0),
                  padding: HtmlPaddings.symmetric(horizontal: 0, vertical: 0),
                ),
                "ul": Style(
                  margin: Margins.all(0),
                  padding: HtmlPaddings.symmetric(horizontal: 0, vertical: 0),
                ),
                "img": Style(
                  width: Width(300, Unit.auto),
                  height: Height(300, Unit.auto),
                ),
              },
          // shrinkWrap: true,
          // style: {
          //   "body": Style(
          //     fontSize: style?.fontSize != null ? FontSize(style!.fontSize!) : null,
          //     color: style?.color != null ? style!.color! : null,
          //     margin: Margins.symmetric(horizontal: 0),
          //     lineHeight: style?.height != null ? LineHeight(style!.height!) : null,
          //     fontWeight: style?.fontWeight != null ? style!.fontWeight! : null,
          //   ),
          //   "p": Style(
          //     fontSize: style?.fontSize != null ? FontSize(style!.fontSize!) : null,
          //     color: style?.color != null ? style!.color! : null,
          //     margin: Margins.symmetric(horizontal: 0),
          //     lineHeight: style?.height != null ? LineHeight(style!.height!) : null,
          //     fontWeight: style?.fontWeight != null ? style!.fontWeight! : null,
          //   )
          // },
        ),
      );
    }
  }

  Widget errorBuilder(context, error) {
    return const Text("error");
  }
}
