import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'sign_in_model.dart';

class SignInParser extends StacParser<SignInModel> {
  @override
  String get type => 'sign_in';

  @override
  SignInModel getModel(Map<String, dynamic> json) => SignInModel.fromJson(json);

  @override
  Widget parse(BuildContext context, SignInModel model) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.title ?? 'Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              model.title ?? 'Welcome Back',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (model.subtitle != null) ...[
              const SizedBox(height: 8),
              Text(model.subtitle!),
            ],
            const SizedBox(height: 32),
            TextField(
              decoration: InputDecoration(
                labelText: model.emailHint ?? 'Email',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: model.passwordHint ?? 'Password',
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                child: const Text('Sign In'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
