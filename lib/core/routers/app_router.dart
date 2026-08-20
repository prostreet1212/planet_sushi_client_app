import 'package:auto_route/auto_route.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:planet_sushi_client_app/core/routers/empty_router_pages.dart';
import 'package:planet_sushi_client_app/core/routers/guards.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/login_screen.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/name_screen/name_screen.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/otp_screen/otp_screen.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/main_screen.dart';
import 'package:planet_sushi_client_app/features/shop/presentation/pages/product_detail_page/product_detail_page.dart';

import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/shop/presentation/pages/menu_page/menu_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: r'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // '/' = начальный маршрут (сейчас home: MainScreen)
    CustomRoute(
      path: '/',
      page: MainRoute.page,
      initial: true,
      children: [
        AutoRoute(
          path: 'menuRouter',
          page: MenuRouter.page,
          children: [
            CustomRoute(path: 'menu', page: MenuRoute.page, initial: true,),
            CustomRoute(path: 'product-detail', page: ProductDetailRoute.page,
              transitionsBuilder: _transitionsBuilder,duration: Duration(milliseconds: 500),),
          ],
        ),
        CustomRoute(path: 'cart', page: CartRoute.page),
        CustomRoute(path: 'profile', page: ProfileRoute.page,guards: [AuthGuard()])

      ],
    ),
    AutoRoute(path: '/login', page: LoginRoute.page),
    AutoRoute(path: '/otp', page: OtpRoute.page),
    AutoRoute(path: '/name', page: NameRoute.page),
  ];
}

var _transitionsBuilder = (context, animation, secondaryAnimation, child) {
  Animatable<Offset> tween = Tween(begin: const Offset(0, -1), end: Offset.zero)
      .chain(CurveTween(curve: Curves.decelerate));
  Animatable<double> fade = Tween(begin: 0.5, end: 1);
  return SlideTransition(
    position: animation.drive(tween),
    child: FadeTransition(
      opacity: animation.drive(fade),
      child: child,
    ),
  );
};
