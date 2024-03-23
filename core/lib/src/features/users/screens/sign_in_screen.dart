import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';

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
  final _emailFb = FieldBloc(
    initialValue: '',
    validator: Validation.email,
  );
  final _passwordFb = FieldBloc(
    initialValue: '',
    validator: const TextValidation(minLength: 1),
  );

  final _form = ListFieldBloc<void>();

  late final _signIn = ref.mutation((ref, arg) async {
    await UsersProviders.signIn(
      ref,
      email: _emailFb.state.value,
      password: _passwordFb.state.value,
      organizationId: widget.organizationId,
    );
  });

  late final _sendPasswordResetEmail = ref.mutation((ref, arg) async {
    await UsersProviders.sendPasswordResetEmail(ref, _emailFb.state.value);
  }, onSuccess: (_, __) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Sent password reset email to ${_emailFb.state.value}!'),
    ));
  });

  @override
  void initState() {
    super.initState();
    _form.addFieldBlocs([_emailFb, _passwordFb]);

    if (!kDebugMode) return;
    _emailFb.changeValue('brexmaster@gmail.com');
    _passwordFb.changeValue(r'Password123$');
  }

  @override
  Widget build(BuildContext context) {
    final isIdle = ref.watchIdle(mutations: [_signIn, _sendPasswordResetEmail]);
    final canSubmitSignInForm = ref.watchCanSubmit(_form);
    final canSubmitResetPasswordForm = ref.watchCanSubmit(_emailFb);

    List<Widget> buildFields() {
      return [
        FieldText(
          fieldBloc: _emailFb,
          converter: FieldConvert.text,
          type: const TextFieldType.email(),
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        FieldText(
          fieldBloc: _passwordFb,
          converter: FieldConvert.text,
          type: const TextFieldType.password(),
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        TextButton.icon(
          onPressed:
              isIdle && canSubmitResetPasswordForm ? () => _sendPasswordResetEmail(null) : null,
          icon: const Icon(Icons.lock_reset_outlined),
          label: const Text('Send reset password email'),
        ),
      ];
    }

    final scaffold = Scaffold(
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
                  onPressed: isIdle && canSubmitSignInForm ? () => _signIn(null) : null,
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

    return SkeletonForm(
      onSubmit: isIdle ? () => _signIn(null) : null,
      child: scaffold,
    );
  }
}
