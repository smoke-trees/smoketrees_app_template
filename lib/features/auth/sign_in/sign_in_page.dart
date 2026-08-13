import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stac/stac.dart';

import '../../../shared/buttons/main_button.dart';
import '../../../shared/fields/custom_password_field.dart';
import '../../../shared/fields/custom_text_field.dart';
import '../../../shared/snackbars/snackbar.dart';
import '../../../theme/colors.dart';
import '../../../utils/assets.dart';
import '../../../utils/console_logger.dart';
import '../../../utils/utils.dart';
import '../user_controller.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  static const String routeName = 'sign_in';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userController = UserController.to;

  final RxBool _isPasswordVisible = false.obs;
  final RxBool _isLoading = false.obs;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    _isLoading.value = true;

    try {
      final response = await _userController.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (response != null && !response.status.error) {
        if (context.mounted) {
          AppSnackBars.customSnackBar(
            context: context,
            message: 'Sign in successful!',
            isError: false,
          );
          await Stac.onCallFromJson(
            StacNavigator.pushReplacementStac('bottom_navigation').toJson(),
            context,
          );
        }
      } else {
        if (context.mounted) {
          AppSnackBars.customSnackBar(
            context: context,
            message: response?.message ?? 'Sign in failed. Please try again.',
            isError: true,
          );
        }
      }
    } catch (e) {
      ConsoleLogger.error(e.toString());
      if (context.mounted) {
        AppSnackBars.customSnackBar(
          context: context,
          message: e?.toString() ?? 'An error occurred. Please try again.',
          isError: true,
        );
      }
      throw e;
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _emailController.text = 'rishi@smoketrees.in';
    _passwordController.text = 'Admin@123';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: 24.p,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                40.h,
                Center(
                  child: Image.asset(
                    AppAssets.appLogo,
                    width: 120,
                    height: 120,
                  ),
                ),
                32.h,
                Text(
                  'Welcome Back',
                  style: Get.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                8.h,
                Text(
                  'Sign in to continue',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey1,
                  ),
                ),
                32.h,
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                16.h,
                CustomPasswordField(
                  controller: _passwordController,
                  isPasswordVisible: _isPasswordVisible,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                16.h,
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                24.h,
                Obx(
                  () => MainButton(
                    title: 'Sign In',
                    onTap: _handleSignIn,
                    showLoader: true,
                    disabled: _isLoading.value,
                    width: double.infinity,
                    color: AppColors.primaryColor,
                    textColor: AppColors.textWhite,
                    borderRadius: 12,
                    fontSize: 16,
                  ),
                ),
                24.h,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey1,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Stac.onCallFromJson(
                          StacNavigator.pushReplacementStac('sign_up').toJson(),
                          context,
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
