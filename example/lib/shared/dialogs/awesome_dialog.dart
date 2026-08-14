import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';

Future<dynamic> showAwesomeDialog({
  required BuildContext context,
  required String title,
  String? message,
  String? okText,
  AwesomeDialogType? type,
  String? cancelText,
  Function? onOkPressed,
  Function? onCancelPressed,
  bool useRootNavigator = true,
  bool dismissOnTouchOutside = true,
  Color? barrierColor,
  bool onDismissCallbackCalled = false,
  void Function(bool)? onDismissCallback,
}) =>
    showDialog(
      context: context,
      useRootNavigator: useRootNavigator,
      barrierDismissible: dismissOnTouchOutside,
      builder: (BuildContext buildContext) => AwesomeDialog(
        title: title,
        description: message,
        okText: okText,
        type: type,
        cancelText: cancelText,
        onOkPressed: onOkPressed,
        onCancelPressed: onCancelPressed,
      ),
      barrierColor: barrierColor ?? const Color(0x80000000),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    )..then<dynamic>(
      (dynamic value) => onDismissCallbackCalled
          ? null
          : onDismissCallback?.call(value ?? false),
    );

class AwesomeDialog extends StatefulWidget {
  const AwesomeDialog({
    Key? key,
    required this.title,
    this.description,
    this.okText,
    this.cancelText,
    this.onOkPressed,
    this.onCancelPressed,
    this.type,
  }) : super(key: key);

  final String title;
  final String? description;
  final String? okText;
  final AwesomeDialogType? type;
  final String? cancelText;
  final Function? onOkPressed;
  final Function? onCancelPressed;

  @override
  _AwesomeDialogState createState() => _AwesomeDialogState();
}

class _AwesomeDialogState extends State<AwesomeDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              if (widget.type != null)
                Positioned(
                  top: -60,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      widget.type == AwesomeDialogType.success
                          ? Icons.check_circle
                          : widget.type == AwesomeDialogType.error
                          ? Icons.cancel
                          : widget.type == AwesomeDialogType.warning
                          ? Icons.error
                          : widget.type == AwesomeDialogType.info
                          ? Icons.info
                          : Icons.help,
                      size: 70,
                      color: widget.type == AwesomeDialogType.success
                          ? Colors.green
                          : widget.type == AwesomeDialogType.error
                          ? Colors.redAccent
                          : widget.type == AwesomeDialogType.warning
                          ? Colors.orange
                          : widget.type == AwesomeDialogType.info
                          ? Colors.blue
                          : Colors.black,
                    ),
                  ),
                ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  25.h,
                  Text(
                    widget.title,
                    style: Get.textTheme.displaySmall?.copyWith(),
                  ),
                  10.h,
                  if (widget.description != null)
                    Text(
                      widget.description!,
                      style: Get.textTheme.bodyMedium?.copyWith(),
                      textAlign: TextAlign.center,
                    ),
                  15.h,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.cancelText != null) ...[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            minimumSize: const Size(150, 40),
                          ),
                          onPressed: () {
                            widget.onCancelPressed?.call();
                            Navigator.of(context).pop();
                          },
                          child: Text(widget.cancelText!),
                        ),
                        10.w,
                      ],
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 40),
                          backgroundColor:
                              widget.type == AwesomeDialogType.success
                              ? Colors.green
                              : widget.type == AwesomeDialogType.error
                              ? Colors.redAccent
                              : widget.type == AwesomeDialogType.warning
                              ? Colors.orange
                              : widget.type == AwesomeDialogType.info
                              ? Colors.blue
                              : Colors.black,
                        ),
                        onPressed: () {
                          widget.onOkPressed?.call();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          widget.okText ?? "OK",
                          style: Get.textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum AwesomeDialogType { success, error, warning, info, question }
