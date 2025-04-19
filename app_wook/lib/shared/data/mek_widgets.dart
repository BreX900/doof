import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/k.dart';
import 'package:mek_gasol/shared/navigation/routes/routes.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) => const AsyncHandler().buildLoadingView();
}

class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback? onTap;

  const ErrorView({
    super.key,
    required this.error,
    this.onTap,
  });

  Widget _buildTitle(Object error) {
    return Text(CoreUtils.translateError(error, fallback: '🤖 My n_m_ _s r_b_t! 🤖'));
  }

  List<Widget> _buildActions(BuildContext context, Object error) {
    if (error is MissingCredentialsFailure) {
      return [
        if (K.signInMethods.contains(SignInMethod.email))
          OutlinedButton(
            onPressed: () => unawaited(const SignInRoute().push(context)),
            child: const Text('SignIn Email'),
          ),
        if (K.signInMethods.contains(SignInMethod.phoneNumber))
          OutlinedButton(
            onPressed: () => unawaited(const SignInPhoneNumberRoute().push(context)),
            child: const Text('SignIn PhoneNumber'),
          ),
        ElevatedButton(
          onPressed: () => unawaited(const SignUpRoute().push(context)),
          child: const Text('Sign Up'),
        ),
      ];
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    return InfoView(
      onTap: error is MissingCredentialsFailure ? null : onTap,
      icon: const Icon(Icons.error_outline),
      title: _buildTitle(error),
      actions: _buildActions(context, error),
    );
  }
}
