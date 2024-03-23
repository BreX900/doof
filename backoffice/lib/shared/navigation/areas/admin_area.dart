import 'package:backoffice/features/categories/screens/admin_categories_screen.dart'
    deferred as admin_categories_screen;
import 'package:backoffice/features/ingredients/screens/admin_ingredients_screen.dart'
    deferred as admin_ingredients_screen;
import 'package:backoffice/features/orders/screens/admin_orders_screen.dart'
    deferred as admin_orders_screen;
import 'package:backoffice/features/organizations/admin_organizations_screen.dart'
    deferred as admin_organizations_screen;
import 'package:backoffice/features/products/screens/admin_products_screen.dart'
    deferred as admin_products_screen;
import 'package:backoffice/features/tickets/screens/admin_tickets_screen.dart'
    deferred as admin_tickets_screen;
import 'package:flutter/material.dart';
import 'package:mek/mek.dart';

enum AdminAreaTab { ingredients, categories, products, tickets, orders }

class AdminArea extends StatefulWidget {
  final String? organizationId;

  const AdminArea({
    super.key,
    required this.organizationId,
  });

  @override
  State<AdminArea> createState() => _AdminAreaState();
}

class _AdminAreaState extends State<AdminArea> {
  var _tab = AdminAreaTab.orders;

  void _changeTabByIndex(int index) {
    setState(() => _tab = AdminAreaTab.values[index]);
  }

  NavigationDestinationBaril _buildTabDestination(AdminAreaTab tab) {
    switch (tab) {
      case AdminAreaTab.orders:
        return const NavigationDestinationBaril(
          icon: Icon(Icons.library_books_outlined),
          label: 'Orders',
        );
      case AdminAreaTab.tickets:
        return const NavigationDestinationBaril(
          icon: Icon(Icons.airplane_ticket_outlined),
          label: 'Tickets',
        );
      case AdminAreaTab.products:
        return const NavigationDestinationBaril(
          icon: Icon(Icons.fastfood_outlined),
          label: 'Products',
        );
      case AdminAreaTab.categories:
        return const NavigationDestinationBaril(
          icon: Icon(Icons.category_outlined),
          label: 'Categories',
        );
      case AdminAreaTab.ingredients:
        return const NavigationDestinationBaril(
          icon: Icon(Icons.list_alt),
          label: 'Ingredients',
        );
    }
  }

  Widget _buildTabView(AdminAreaTab tab, String organizationId) {
    return switch (tab) {
      AdminAreaTab.orders => DeferredLibraryBuilder(
          loader: admin_orders_screen.loadLibrary,
          builder: (context) =>
              admin_orders_screen.AdminOrdersScreen(organizationId: organizationId),
        ),
      AdminAreaTab.tickets => DeferredLibraryBuilder(
          loader: admin_tickets_screen.loadLibrary,
          builder: (context) =>
              admin_tickets_screen.AdminTicketsScreen(organizationId: organizationId),
        ),
      AdminAreaTab.products => DeferredLibraryBuilder(
          loader: admin_products_screen.loadLibrary,
          builder: (context) =>
              admin_products_screen.AdminProductsScreen(organizationId: organizationId),
        ),
      AdminAreaTab.categories => DeferredLibraryBuilder(
          loader: admin_categories_screen.loadLibrary,
          builder: (context) =>
              admin_categories_screen.AdminCategoriesScreen(organizationId: organizationId),
        ),
      AdminAreaTab.ingredients => DeferredLibraryBuilder(
          loader: admin_ingredients_screen.loadLibrary,
          builder: (context) =>
              admin_ingredients_screen.AdminIngredientsScreen(organizationId: organizationId),
        ),
    };
  }

  Widget _buildBody(String organizationId) {
    return IndexedStack(
      index: _tab.index,
      children: AdminAreaTab.values.map((tab) => _buildTabView(tab, organizationId)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final organizationId = widget.organizationId;

    if (organizationId == null) {
      return DeferredLibraryBuilder(
        loader: admin_organizations_screen.loadLibrary,
        builder: (context) => admin_organizations_screen.AdminOrganizationsScreen(
          selectedOrganizationId: organizationId,
        ),
      );
    }

    return NavigationBaril(
      selectedIndex: _tab.index,
      onDestinationSelected: _changeTabByIndex,
      destinations: AdminAreaTab.values.map(_buildTabDestination).toList(),
      child: _buildBody(organizationId),
    );
  }
}
