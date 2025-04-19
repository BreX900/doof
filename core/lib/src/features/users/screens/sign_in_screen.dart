import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignInScreen extends ConsumerStatefulWidget {
  final String? organizationId;
  final VoidCallback? onSignUp;

  const SignInScreen({
    super.key,
    this.organizationId,
    this.onSignUp,
  });

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailFb = FormControlTyped<String>(
    initialValue: '',
    validators: [ValidatorsTyped.required(), ValidatorsTyped.email()],
  );
  final _passwordFb = FormControlTyped<String>(
    initialValue: '',
    validators: [ValidatorsTyped.required()],
  );

  late final _form = FormArray<void>([_emailFb, _passwordFb]);

  late final _signIn = ref.mutation((ref, arg) async {
    await UsersProviders.signIn(
      ref,
      email: _emailFb.value,
      password: _passwordFb.value,
      organizationId: widget.organizationId,
    );
  }, onError: (_, error) {
    CoreUtils.showErrorSnackBar(context, error);
  });

  late final _sendPasswordResetEmail = ref.mutation((ref, arg) async {
    await UsersProviders.sendPasswordResetEmail(ref, _emailFb.value);
  }, onError: (_, error) {
    CoreUtils.showErrorSnackBar(context, error);
  }, onSuccess: (_, __) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Sent password reset email to ${_emailFb.value}!'),
    ));
  });

  @override
  void initState() {
    super.initState();

    if (!kDebugMode) return;
    _emailFb.updateValue('brexmaster@gmail.com');
    _passwordFb.updateValue(r'Password123$');
  }

  @override
  Widget build(BuildContext context) {
    final isIdle = !ref.watchIsMutating([_signIn, _sendPasswordResetEmail]);
    final signIn = _form.handleSubmit(_signIn.run);
    final sendPasswordResetEmail = _emailFb.handleSubmit(_sendPasswordResetEmail.run);

    List<Widget> buildFields() {
      return [
        ReactiveTypedTextField(
          formControl: _emailFb,
          variant: const TextFieldVariant.email(),
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        ReactiveTypedTextField(
          formControl: _passwordFb,
          variant: const TextFieldVariant.password(),
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        TextButton.icon(
          onPressed: isIdle ? () => sendPasswordResetEmail(null) : null,
          icon: const Icon(Icons.lock_reset_outlined),
          label: const Text('Send reset password email'),
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...buildFields(),
            const SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: isIdle ? () => signIn(null) : null,
                  icon: const Icon(Icons.login),
                  label: const Text('Sign In'),
                ),
                if (widget.onSignUp != null) ...[
                  const SizedBox(height: 16.0),
                  OutlinedButton.icon(
                    onPressed: isIdle ? widget.onSignUp : null,
                    icon: const Icon(Icons.app_registration),
                    label: const Text('Sign Up'),
                  ),
                ],
                const SizedBox(height: 16.0),
              ],
            )
          ],
        ),
      ),
    );
  }
}
