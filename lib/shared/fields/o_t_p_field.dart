import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:smoketrees_app_template/theme/colors.dart';

class OTPField extends StatefulWidget {
  const OTPField({
    Key? key,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.onCompleted,
  }) : super(key: key);

  final FocusNode? focusNode;

  final String? Function(String?)? validator;

  final Function(String)? onChanged;
  final Function(String)? onCompleted;

  @override
  _OTPFieldState createState() => _OTPFieldState();
}

class _OTPFieldState extends State<OTPField> {
  late final SmsRetriever smsRetriever;
  late final TextEditingController pinController;
  @override
  void initState() {
    super.initState();
    pinController = TextEditingController();
    smsRetriever = SmsRetrieverImpl(SmartAuth());
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 50,
    textStyle: const TextStyle(
      fontSize: 20,
      color: AppColors.textDark,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      color: AppColors.white,
      border: Border.all(color: AppColors.grey, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  );
  final focusPinTheme = PinTheme(
    width: 56,
    height: 50,
    textStyle: const TextStyle(
      fontSize: 20,
      color: AppColors.textDark,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      color: AppColors.white,
      border: Border.all(color: AppColors.grey, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Pinput(
      length: 6,
      onCompleted: widget.onCompleted,
      onChanged: widget.onChanged,
      focusNode: widget.focusNode,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme,
      // inputFormatters: [
      //   FilteringTextInputFormatter.digitsOnly,],
      submittedPinTheme: defaultPinTheme,
      controller: pinController,
      validator: widget.validator,
      smsRetriever: smsRetriever,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      // onCompleted: (pin) =>print(pin),
    );
  }
}

class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    return smartAuth.removeSmsListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final res = await smartAuth.getSmsCode(useUserConsentApi: true);
    if (res.succeed && res.codeFound) {
      return res.code!;
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => false;
}
