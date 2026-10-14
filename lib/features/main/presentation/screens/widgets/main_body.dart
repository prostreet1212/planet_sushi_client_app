import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/providers/main_screen_state.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/widgets/general_widgets/animated_indexed_stack1.dart';
import 'package:provider/provider.dart';

import '../../../../../core/routers/app_router.dart';
import '../../../../auth/presentation/cubits/auth_status_cubit/auth_status_cubit.dart';
import '../../../../cart/presentation/cubits/cart_cubit.dart';
import '../../../../shop/presentation/cubits/catalog_cubit/catalog_cubit.dart';
import 'general_widgets/animated_indexed_stack.dart';
import 'main_nav_bar.dart';
import 'main_nav_fab.dart';

class MainBody extends StatefulWidget {
  const MainBody({super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {

  @override
  void initState() {
    super.initState();
    //_bootstrap();
  }

  @override
  void dispose() {
    context.read<AuthStatusCubit>().close();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    // 1. Сначала каталог: getCatalog() внутри await-ит syncFromRemote()
    await context.read<CatalogCubit>().getCatalog();
    if (!mounted) return;
    // 2. Только теперь читаем корзину — products уже обновлены
    await context.read<CartCubit>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.yellow),
        useMaterial3: false,
        //fontFamily: 'Custom',
        //fontFamily: 'RobotoCondensed',
        fontFamily: 'RobotoCondensedRegular',
      ),
      child: AutoTabsRouter.builder(
        routes: [
          const MenuRoute(),
          const CartRoute(),
          const ProfileRoute(),
          //LoginRoute(),
        ],
        builder: (context, children, tabsRouter) {
          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              extendBody: true,
              appBar: AppBar(
                title: const Text('Планета суши'),
                leading: AutoLeadingButton(
                  showIfChildCanPop: true,
                  showIfParentCanPop: false,
                ),
                automaticallyImplyLeading: true,
              ),
              // body: MainBody(),
              body: AnimatedIndexedStack1(
                index: tabsRouter.activeIndex,
                children: children,
                duration: Duration(milliseconds: 500),
                curve: Easing.legacy,
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              //floatingActionButtonLocation: const FixedCenterDockedFabLocation(),
              floatingActionButton: const MainNavFab(),
              bottomNavigationBar: const MainNavBar(),
            ),
          );
        },
      ),

      /*SafeArea(
            child: Scaffold(
              extendBody: true,
              appBar: AppBar(title: const Text('Планета суши'),
                leading:AutoLeadingButton(),
                automaticallyImplyLeading: true,),
              body: MainBody(),
              floatingActionButtonLocation: FloatingActionButtonLocation
                  .centerDocked,
              floatingActionButton: const MainNavFab(),
              bottomNavigationBar: const MainNavBar(),
            ),
          ),*/
      /*AutoTabsRouter(
            routes: [
              MenuRoute(), const CartRoute(), const ProfileRoute(),
            ],

            builder: (context,child){
              return SafeArea(
                child: Scaffold(
                  extendBody: true,
                  appBar: AppBar(title: const Text('Планета суши'),
                    leading:AutoLeadingButton(),
                  automaticallyImplyLeading: true,),
                 // body: MainBody(),
                  body: child,
                  floatingActionButtonLocation: FloatingActionButtonLocation
                      .centerDocked,
                  floatingActionButton: const MainNavFab(),
                  bottomNavigationBar: const MainNavBar(),
                ),
              );
            },
          ),*/
    );
  }
}
