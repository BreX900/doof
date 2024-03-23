import 'package:app_button/shared/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StoreBottomBar extends StatelessWidget {
  final String organizationId;

  const StoreBottomBar({
    super.key,
    required this.organizationId,
  });

  List<String> _generateRoutes() {
    return [
      ProductsRoute(organizationId).location,
      CartRoute(organizationId).location,
      OrdersRoute(organizationId).location,
    ];
  }

  int _calculateSelectedIndex(BuildContext context) {
    final state = GoRouterState.of(context);
    final location = state.uri.path;
    return _generateRoutes().indexWhere(location.startsWith);
  }

  void _changeLocation(BuildContext context, int index) {
    context.go(_generateRoutes().elementAt(index));
  }

  Widget _buildBottomBar(BuildContext context, int selectedIndex) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => _changeLocation(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Carrello',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books_outlined),
          label: 'Orders',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return _buildBottomBar(context, selectedIndex);
  }
}
