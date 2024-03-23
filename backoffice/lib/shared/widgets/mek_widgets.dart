import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:mek/mek.dart';

class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback? onTap;

  const ErrorView({
    super.key,
    required this.error,
    this.onTap,
  });

  static Widget buildByData(BuildContext context, ErrorData data) {
    return ErrorView(error: data.error, onTap: data.onTap);
  }

  Widget _buildTitle(Object error) {
    return Text(CoreUtils.translateError(error, fallback: '🤖 My n_m_ _s r_b_t! 🤖'));
  }

  List<Widget> _buildActions(BuildContext context, Object error) {
    // TODO: Uncomment
    // if (error is MissingCredentialsFailure) {
    //   return [
    //     if (K.signInMethods.contains(SignInMethod.email))
    //       OutlinedButton(
    //         onPressed: () => unawaited(const SignInRoute().push(context)),
    //         child: const Text('SignIn Email'),
    //       ),
    //     if (K.signInMethods.contains(SignInMethod.phoneNumber))
    //       OutlinedButton(
    //         onPressed: () => unawaited(const SignInPhoneNumberRoute().push(context)),
    //         child: const Text('SignIn PhoneNumber'),
    //       ),
    //     ElevatedButton(
    //       onPressed: () => unawaited(const SignUpRoute().push(context)),
    //       child: const Text('Sign Up'),
    //     ),
    //   ];
    // }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final child = InfoTile(
      onTap: error is MissingCredentialsFailure ? null : onTap,
      icon: const Icon(Icons.error_outline),
      title: _buildTitle(error),
      actions: _buildActions(context, error),
    );
    return buildWithMaterial(context, child);
  }
}
