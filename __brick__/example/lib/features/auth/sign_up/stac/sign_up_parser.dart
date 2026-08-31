import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'sign_up_model.dart';

class SignUpParser extends StacParser<SignUpModel> {
  @override
  String get type => 'sign_up';

  @override
  SignUpModel getModel(Map<String, dynamic> json) => SignUpModel.fromJson(json);

  @override
  Widget parse(BuildContext context, SignUpModel model) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.title ?? 'Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              model.title ?? 'Create Account',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (model.subtitle != null) ...[
              const SizedBox(height: 8),
              Text(model.subtitle!),
            ],
            const SizedBox(height: 32),
            TextField(
              decoration: InputDecoration(
                labelText: model.nameHint ?? 'Name',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
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
                child: const Text('Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
