import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _emailFb = FormControlTyped(
    initialValue: '',
    validators: [ValidatorsTyped.email()],
  );
  final _passwordFb = FormControlTyped(
    initialValue: '',
    validators: [ValidatorsTyped.password()],
  );
  final _passwordConfirmationFb = FormControlTyped(
    initialValue: '',
    validators: [ValidatorsTyped.password()],
  );

  late final _form = FormArray<void>([_emailFb, _passwordFb, _passwordConfirmationFb]);

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  late final _signUp = ref.mutation((ref, _) async {
    await UsersProviders.signUp(
      ref,
      email: _emailFb.value,
      password: _passwordFb.value,
      passwordConfirmation: _passwordConfirmationFb.value,
      organizationId: Env.organizationId,
    );
  }, onError: (_, error) {
    CoreUtils.showErrorSnackBar(context, error);
  });

  @override
  Widget build(BuildContext context) {
    final isIdle = !ref.watchIsMutating([_signUp]);
    final signUp = _form.handleSubmit(_signUp.run);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up!'),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: isIdle ? () => signUp(null) : null,
              child: const Text('Viva Dart!'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ReactiveTypedTextField(
              formControl: _emailFb,
              variant: const TextFieldVariant.email(),
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            ReactiveTypedTextField(
              formControl: _passwordFb,
              variant: const TextFieldVariant.password(),
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            ReactiveTypedTextField(
              formControl: _passwordConfirmationFb,
              variant: const TextFieldVariant.password(),
              decoration: const InputDecoration(
                labelText: 'Password Confirmation',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
