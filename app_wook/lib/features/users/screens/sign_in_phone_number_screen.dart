import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/shared/navigation/routes/routes.dart';

class SignInPhoneNumberScreen extends ConsumerStatefulWidget {
  final String? verificationId;

  const SignInPhoneNumberScreen({super.key, this.verificationId});

  @override
  ConsumerState<SignInPhoneNumberScreen> createState() => _SignInPhoneNumberScreenState();
}

class _SignInPhoneNumberScreenState extends ConsumerState<SignInPhoneNumberScreen> {
  late final _mutation = MutationController(ref);

  final _phoneNumberFb = FormControlTyped(initialValue: '');

  String? get _verificationId => widget.verificationId;

  final _sentCodeFb = FormControlTyped(initialValue: '');

  @override
  void dispose() {
    _mutation.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (kReleaseMode) return;
    _phoneNumberFb.updateValue('+39 346 811 4956');
  }

  void _signIn() => _mutation(
    (ref) async => await UsersProviders.signInWithPhoneNumber(ref, _phoneNumberFb.value),
    onError: (error, _) => CoreUtils.showErrorSnackBar(context, error),
    onSettled: (_, result) {
      if (result != null) {
        final route = SignInPhoneNumberRoute(verificationId: result);
        context.pushReplacement(route.location, extra: route);
      }
    },
  );

  void _confirmVerification() => _mutation((ref) async {
    await UsersProviders.confirmPhoneNumberVerification(
      ref,
      _verificationId!,
      organizationId: Env.organizationId,
      code: _sentCodeFb.value,
    );
  }, onError: (error, _) => CoreUtils.showErrorSnackBar(context, error));

  @override
  Widget build(BuildContext context) {
    final isIdle = !ref.watch(_mutation.provider.isPending);
    final signIn = _phoneNumberFb.handleSubmit(_signIn);
    final confirmVerification = _sentCodeFb.handleSubmit(_confirmVerification);

    return Scaffold(
      appBar: AppBar(title: const Text('Phone Number')),
      body: _buildBody(context),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: isIdle ? (_verificationId == null ? signIn : confirmVerification) : null,
              child: const Text('Sign In'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final Widget content;
    if (_verificationId == null) {
      content = Column(
        children: [
          ReactiveTypedTextField(
            formControl: _phoneNumberFb,
            variant: const TextFieldVariant.phoneNumber(),
          ),
        ],
      );
    } else {
      content = Column(
        children: [
          ReactiveTypedTextField(
            formControl: _sentCodeFb,
            variant: const TextFieldVariant.integer(),
          ),
        ],
      );
    }

    return Padding(padding: const EdgeInsets.all(16.0), child: content);
  }
}
