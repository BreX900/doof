import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/shared/widgets/guards/modules_guard.dart';

class SignOutIconButton extends StatelessWidget {
  const SignOutIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<void>(
      icon: const Icon(Icons.logout),
      itemBuilder: (context) {
        return [
          PopupMenuItem(onTap: () => Instances.auth.signOut(), child: const Text('Sign Out')),
          if (Env.flavour != EnvFlavour.frontend && Env.flavour != EnvFlavour.backoffice)
            PopupMenuItem(
              onTap: () => unawaited(AppsGuard.of(context).select(null)),
              child: const Text('Change App'),
            ),
        ];
      },
    );
  }
}
