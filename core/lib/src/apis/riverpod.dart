import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:pull_to_refresh_plus/pull_to_refresh_plus.dart';

/// Version 2.0.0

class AsyncConfig extends InheritedWidget {
  final bool refreshableScroll;

  const AsyncConfig({
    super.key,
    required this.refreshableScroll,
    required super.child,
  });

  static AsyncConfig from({
    required BuildContext context,
    bool refreshable = true,
    required Widget child,
  }) {
    final platform = Theme.of(context).platform;
    final isMobile = platform == TargetPlatform.android || platform == TargetPlatform.iOS;

    return AsyncConfig(
      refreshableScroll: isMobile && refreshable,
      child: child,
    );
  }

  static AsyncConfig of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AsyncConfig>();
    return result ?? from(context: context, child: const SizedBox.shrink());
  }

  @override
  bool updateShouldNotify(AsyncConfig oldWidget) =>
      refreshableScroll != oldWidget.refreshableScroll;
}

mixin RefreshableConsumer<W extends ConsumerStatefulWidget> on ConsumerState<W> {
  static RefreshableConsumer? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<RefreshableConsumer>();
  }

  void invalidate();
}

abstract class AsyncConsumerWidget extends ConsumerStatefulWidget with AsyncConsumerStatefulWidget {
  const AsyncConsumerWidget({super.key});

  Widget build(BuildContext context, WidgetRef ref);

  @override
  ConsumerState<AsyncConsumerWidget> createState() => _AsyncConsumerWidgetState();
}

class _AsyncConsumerWidgetState extends ConsumerState<AsyncConsumerWidget> with AsyncConsumerState {
  @override
  Widget build(BuildContext context) => widget.build(context, ref);
}

mixin AsyncConsumerStatefulWidget on ConsumerStatefulWidget {
  ProviderBase<Object?> get asyncProvider;
}

mixin AsyncConsumerState<W extends AsyncConsumerStatefulWidget> on ConsumerState<W>
    implements RefreshableConsumer<W> {
  @override
  void invalidate() {
    ProviderScope.containerOf(context, listen: false).invalidateFrom(widget.asyncProvider);
  }
}

extension BuildViewAsyncValue<T> on AsyncValue<T> {
  Widget buildView({
    bool? refreshableScroll,
    bool skipError = true,
    required Widget Function(T data) data,
  }) {
    return when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      skipError: skipError,
      loading: () {
        return const Builder(builder: DataBuilders.buildLoading);
      },
      error: (error, _) {
        return Builder(builder: (context) {
          final refreshableConsumer = RefreshableConsumer.maybeOf(context);

          return DataBuilders.buildError(
            context,
            error,
            onTap: refreshableConsumer?.invalidate,
          );
        });
      },
      data: (data_) {
        final child = data(data_);

        return Builder(builder: (context) {
          if (!(refreshableScroll ?? AsyncConfig.of(context).refreshableScroll)) return child;

          final refreshableConsumer = RefreshableConsumer.maybeOf(context);
          if (refreshableConsumer == null) return child;

          return AsyncRefresher(
            state: this,
            child: child,
          );
        });
      },
    );
  }
}

class AsyncViewBuilder<T> extends StatelessWidget {
  final AsyncValue<T> state;
  final bool? refreshableScroll;
  final bool skipError;
  final Widget Function(BuildContext context, T data) builder;

  const AsyncViewBuilder({
    super.key,
    required this.state,
    this.refreshableScroll,
    this.skipError = true,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return state.buildView(
      skipError: skipError,
      data: (data) => builder(context, data),
    );
  }
}

class AsyncRefresher extends StatefulWidget {
  final AsyncValue<Object?> state;
  final Widget child;

  const AsyncRefresher({
    super.key,
    required this.state,
    required this.child,
  });

  RefreshStatus get _refreshStatus {
    if (state.isLoading) {
      return RefreshStatus.refreshing;
    }
    if (state.hasError) {
      return RefreshStatus.failed;
    }
    return RefreshStatus.idle;
  }

  @override
  State<AsyncRefresher> createState() => _AsyncRefresherState();
}

class _AsyncRefresherState extends State<AsyncRefresher> {
  final _controller = RefreshController();

  @override
  void initState() {
    super.initState();
    _controller.headerMode!.value = widget._refreshStatus;
  }

  @override
  void didUpdateWidget(covariant AsyncRefresher oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.headerMode!.value = widget._refreshStatus;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _invalidate() {
    if (widget.state.isLoading) return;
    RefreshableConsumer.maybeOf(context)!.invalidate();
  }

  Widget _buildSmartRefresher(Widget child) {
    return SmartRefresher(
      controller: _controller,
      onRefresh: _invalidate,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child is ScrollView || widget.child is SingleChildScrollView) {
      return _buildSmartRefresher(widget.child);
    }

    return LayoutBuilder(builder: (context, constraints) {
      final child = SingleChildScrollView(
        child: SizedBox(
          height: constraints.maxHeight,
          child: widget.child,
        ),
      );
      return _buildSmartRefresher(child);
    });
  }
}

class AsyncTableConsumer<T> extends ConsumerWidget {
  final ProviderListenable<AsyncValue<T>> provider;
  final Widget Function(BuildContext context, WidgetRef ref, T data) bodyBuilder;
  final Widget footer;

  const AsyncTableConsumer({
    super.key,
    required this.provider,
    required this.bodyBuilder,
    required this.footer,
  });

  Widget _buildTable(BuildContext context, WidgetRef ref, bool isLoading, T data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isLoading) const LinearProgressIndicator(),
        Expanded(
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.minWidth),
                    child: bodyBuilder(context, ref, data),
                  ),
                );
              },
            ),
          ),
        ),
        footer,
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);

    return AsyncViewBuilder(
      state: state,
      skipError: false,
      builder: (context, data) => _buildTable(context, ref, state.isLoading, data),
    );
  }
}
