import 'package:auto_route/auto_route.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_router.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // Ваше условие
    bool isAuthenticated =  di.sl<Supabase>().client.auth.currentUser?.id!=null;

    if (isAuthenticated) {
      // Разрешаем переход дальше
      resolver.next(true);
    } else {
      // Отменяем переход на ProfileRoute и редиректим на LoginRoute
      resolver.next(false);
      router.root.push(const LoginRoute());
    }
  }
}