import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/shared/widgets/sign_out_icon_button.dart';

class SignEmailScreen extends ConsumerStatefulWidget {
  const SignEmailScreen({super.key});

  @override
  ConsumerState<SignEmailScreen> createState() => _SignEmailScreenState();
}

class _SignEmailScreenState extends ConsumerState<SignEmailScreen> {
  late final _mutation = MutationController(ref);

  @override
  void dispose() {
    _mutation.dispose();
    super.dispose();
  }

  void _sendEmailVerification() => _mutation(
    (ref) async => await Instances.auth.currentUser!.sendEmailVerification(),
    onError: (error, _) => CoreUtils.showErrorSnackBar(context, error),
    onSettled: (_, result) {
      if (result == null) {
        ScaffoldMessenger.of(context).showMaterialBanner(
          const MaterialBanner(
            content: Text('Verification email sent!'),
            actions: [HideBannerButton()],
          ),
        );
      }
    },
  );

  void _reload() => _mutation((ref) async {
    await Instances.auth.currentUser!.reload();
    ref.invalidate(UsersProviders.currentAuth);
  }, onError: (error, _) => CoreUtils.showErrorSnackBar(context, error));

  @override
  Widget build(BuildContext context) {
    final isIdle = !ref.watch(_mutation.provider.isMutating);

    return Scaffold(
      appBar: AppBar(
        leading: const SignOutIconButton(),
        title: const Text('Verify email!'),
        actions: [IconButton(onPressed: isIdle ? _reload : null, icon: const Icon(Icons.refresh))],
      ),
      body: InfoView(
        onTap: isIdle ? _reload : null,
        icon: const Icon(Icons.mark_email_unread_outlined),
        title: Text(
          'Please verify your email:\n'
          '${Instances.auth.currentUser!.email}',
        ),
        description: const Text('Tap to verify that you have reset the email'),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: isIdle ? _sendEmailVerification : null,
              child: const Text('Send email verification'),
            ),
          ),
        ],
      ),
    );
  }
}
