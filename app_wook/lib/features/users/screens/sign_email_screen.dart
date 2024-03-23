import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/shared/widgets/bottom_button_bar.dart';
import 'package:mek_gasol/shared/widgets/hide_banner_button.dart';
import 'package:mek_gasol/shared/widgets/sign_out_icon_button.dart';

class SignEmailScreen extends ConsumerStatefulWidget {
  const SignEmailScreen({super.key});

  @override
  ConsumerState<SignEmailScreen> createState() => _SignEmailScreenState();
}

class _SignEmailScreenState extends ConsumerState<SignEmailScreen> {
  late final _sendEmailVerification = ref.mutation((ref, arg) async {
    await Instances.auth.currentUser!.sendEmailVerification();
  }, onSuccess: (_, __) {
    ScaffoldMessenger.of(context).showMaterialBanner(const MaterialBanner(
      content: Text('Verification email sent!'),
      actions: [HideBannerButton()],
    ));
  });

  late final _reload = ref.mutation((ref, arg) async {
    await Instances.auth.currentUser!.reload();
    ref.invalidate(UsersProviders.currentAuth);
  });

  @override
  Widget build(BuildContext context) {
    final isIdle = ref.watchIdle(mutations: [_sendEmailVerification, _reload]);

    return Scaffold(
      appBar: AppBar(
        leading: const SignOutIconButton(),
        title: const Text('Verify email!'),
        actions: [
          IconButton(
            onPressed: isIdle ? () => _reload(null) : null,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: InfoTile(
        onTap: isIdle ? () => _reload(null) : null,
        icon: const Icon(Icons.mark_email_unread_outlined),
        title: Text('Please verify your email:\n'
            '${Instances.auth.currentUser!.email}'),
        description: const Text('Tap to verify that you have reset the email'),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: isIdle ? () => _sendEmailVerification(null) : null,
              child: const Text('Send email verification'),
            ),
          ),
        ],
      ),
    );
  }
}
