import 'dart:async';

import 'package:app_button/apis/flutter_svg/svg_icon.dart';
import 'package:app_button/shared/data/r.dart';
import 'package:app_button/shared/navigation/routes.dart';
import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _stateProvider = FutureProvider.family((ref, String organizationId) async {
  final user = await ref.watch(UsersProviders.currentAuth.future);

  return (user: user,);
});

class StoreDrawer extends ConsumerStatefulWidget {
  final String organizationId;

  const StoreDrawer({
    super.key,
    required this.organizationId,
  });

  @override
  ConsumerState<StoreDrawer> createState() => _StoreDrawerState();
}

class _StoreDrawerState extends ConsumerState<StoreDrawer> {
  Widget _buildDrawer({required User? user}) {
    final email = user?.email;

    return Column(
      children: [
        ListTile(
          onTap: () => ServicesRoute(widget.organizationId).go(context),
          leading: const SvgIcon.asset(R.svgsTableService),
          title: const Text('Richiedi servizio al tavolo'),
          subtitle: const Text('Hai sete? Fame? Inviaci una richiesta e arriviamo!'),
        ),
        const Spacer(),
        ListTile(
          onTap: () => const QrCodeRoute().go(context),
          leading: const Icon(Icons.qr_code_scanner),
          title: const Text('Scanerrizza un altro QRCode'),
        ),
        if (user == null)
          ListTile(
            onTap: () {
              Scaffold.of(context).closeDrawer();
              unawaited(SignInPhoneNumberRoute(
                organizationId: widget.organizationId,
                shouldPop: true,
              ).push(context));
            },
            leading: const Icon(Icons.login),
            title: const Text('Login'),
          )
        else
          ListTile(
            onTap: () async {
              Scaffold.of(context).closeDrawer();
              await UsersProviders.signOut();
            },
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            subtitle: email != null ? Text(email) : null,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_stateProvider(widget.organizationId));

    return Drawer(
      child: SafeArea(
        child: state.buildView(
          data: (data) => _buildDrawer(user: data.user),
        ),
      ),
    );
  }
}
