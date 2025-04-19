import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';

/// Version 1.0.0
extension BuildViewAsyncValue<T> on AsyncValue<T> {
  Widget buildView({
    required void Function() onRefresh,
    required Widget Function(T data) data,
  }) {
    return buildWhen(
      loading: LoadingView.new,
      error: (error, _) => ErrorView(error: error),
      data: data,
    );
  }
}
