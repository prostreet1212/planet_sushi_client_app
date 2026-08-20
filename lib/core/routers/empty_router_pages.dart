import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'MenuRouter')
class MenuRouterPage extends StatelessWidget {
  const MenuRouterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}