// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// extension SafeRefExtenions<TRef extends Ref<TState>, TState> on TRef {
//   Ref<TState> get safe => _SafeRef(this);
// }
//
// class _SafeRef<State> implements Ref<State> {
//   final Ref<State> _ref;
//   var _isClosed = false;
//
//   _SafeRef(this._ref) {
//     _ref.onCancel(() {
//       _isClosed = true;
//     });
//   }
//
//   Ref<State> get ref {
//     if (_isClosed) throw StateError('Ref is closed');
//     return _ref;
//   }
//
//   @override
//   ProviderContainer get container => ref.container;
//
//   @override
//   bool exists(ProviderBase<Object?> provider) => ref.exists(provider);
//
//   @override
//   void invalidate(ProviderOrFamily provider) => ref.invalidate(provider);
//
//   @override
//   void invalidateSelf() => ref.invalidateSelf();
//
//   @override
//   ProviderSubscription<T> listen<T>(
//     AlwaysAliveProviderListenable<T> provider,
//     void Function(T? previous, T next) listener, {
//     void Function(Object error, StackTrace stackTrace)? onError,
//     bool fireImmediately = false,
//   }) {
//     return ref.listen(provider, listener, onError: onError, fireImmediately: fireImmediately);
//   }
//
//   @override
//   void listenSelf(
//     void Function(State? previous, State next) listener, {
//     void Function(Object error, StackTrace stackTrace)? onError,
//   }) {
//     ref.listenSelf(listener, onError: onError);
//   }
//
//   @override
//   void notifyListeners() => ref.notifyListeners();
//
//   @override
//   void onAddListener(void Function() cb) => ref.onAddListener(cb);
//
//   @override
//   void onCancel(void Function() cb) => ref.onCancel(cb);
//
//   @override
//   void onDispose(void Function() cb) => ref.onDispose(cb);
//
//   @override
//   void onRemoveListener(void Function() cb) => ref.onRemoveListener(cb);
//
//   @override
//   void onResume(void Function() cb) => ref.onResume(cb);
//
//   @override
//   T read<T>(ProviderListenable<T> provider) => ref.read(provider);
//
//   @override
//   T refresh<T>(Refreshable<T> provider) => ref.refresh(provider);
//
//   @override
//   T watch<T>(AlwaysAliveProviderListenable<T> provider) => ref.watch(provider);
// }
