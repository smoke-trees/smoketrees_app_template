import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stac/stac.dart';
import '../user_controller.dart';
import '../../../shared/buttons/main_button.dart';
import '../../../shared/fields/custom_password_field.dart';
import '../../../shared/fields/custom_text_field.dart';
import '../../../shared/snackbars/snackbar.dart';
import '../../../theme/colors.dart';
import '../../../utils/utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _userController = UserController.to;

  final RxBool _isPasswordVisible = false.obs;
  final RxBool _isConfirmPasswordVisible = false.obs;
  final RxBool _isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: 24.p,
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 16,
              children: [
                Text(
                  'Welcome to SmokeTrees',
                  style: Get.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),

                Text(
                  'Sign up to continue',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey1,
                  ),
                ),
                CustomTextField(
                  controller: _firstNameController,
                  labelText: 'First Name',
                  hintText: 'Enter your first name',
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.namePrefix],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _lastNameController,
                  labelText: 'Last Name',
                  hintText: 'Enter your last name',
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.nameSuffix],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
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
                CustomPasswordField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  isPasswordVisible: _isPasswordVisible,
                ),
                CustomPasswordField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Confirm your password',
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  isPasswordVisible: _isConfirmPasswordVisible,
                ),
                Obx(
                  () => MainButton(
                    title: 'Sign Up',
                    onTap: _handleSignUp,
                    showLoader: true,
                    disabled: _isLoading.value,
                    width: double.infinity,
                    color: AppColors.primaryColor,
                    textColor: AppColors.textWhite,
                    borderRadius: 12,
                    fontSize: 16,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey1,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Stac.onCallFromJson(
                          StacNavigator.pushReplacementStac('sign_in').toJson(),
                          context,
                        );
                      },
                      child: Text(
                        'Sign In',
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

  Future<void> _handleSignUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      _isLoading.value = true;
      final response = await _userController.signUp(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      _isLoading.value = false;

      if (response?.status.error ?? true) {
        // Navigate to the next page or show success message
        if (context.mounted) {
          AppSnackBars.customSnackBar(
            context: context,
            message: response?.message ?? 'Sign up failed. Please try again.',
            isError: true,
          );
        }
      } else {
        // Navigate to the next page or show success message
        if (context.mounted) {
          AppSnackBars.customSnackBar(
            context: context,
            message: 'Sign up successful!',
            isError: false,
          );
          await Stac.onCallFromJson(
            StacNavigator.pushReplacementStac('bottom_navigation').toJson(),
            context,
          );
        }
      }
    }
  }
}
