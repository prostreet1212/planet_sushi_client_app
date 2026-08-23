import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/core/routers/app_router.dart';
import 'package:planet_sushi_client_app/features/cart/presentation/cubits/cart_cubit.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/providers/main_screen_state.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/widgets/general_widgets/animated_indexed_stack1.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/widgets/general_widgets/fixed_center_docked_fab_location.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/widgets/main_body.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/widgets/main_nav_bar.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/widgets/main_nav_fab.dart';
import 'package:planet_sushi_client_app/features/shop/presentation/cubits/catalog_cubit/catalog_cubit.dart';
import 'package:provider/provider.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;

import '../../../cart/presentation/pages/cart_page.dart';
import '../../../shop/presentation/pages/menu_page/menu_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Строитель мэйнскрин');
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<CartCubit>()..loadCart(),
        ),
        BlocProvider<CatalogCubit>(
          create: (context) =>
          di.sl<CatalogCubit>()
            ..getCatalog(),
        ),
      ],
      child: Theme(
        data: ThemeData(
            colorScheme: .fromSeed(seedColor: Colors.yellow),
            useMaterial3: false,
            //fontFamily: 'Custom',
            //fontFamily: 'RobotoCondensed',
            fontFamily: 'RobotoCondensedRegular'
        ),
        child:AutoTabsRouter.builder(
          routes: [
            MenuRoute(),
            CartRoute(),
            const ProfileRoute(),
            //LoginRoute(),
          ],
          builder:(context, children, tabsRouter) {
            return SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                extendBody: true,
                appBar: AppBar(title: const Text('Планета суши'),
                  leading:AutoLeadingButton(
                    showIfChildCanPop: true,
                    showIfParentCanPop: false,
                  ),
                  automaticallyImplyLeading: true,),
                // body: MainBody(),
                body: AnimatedIndexedStack1(
                  index: tabsRouter.activeIndex,
                  children: children,
                  duration: Duration(milliseconds: 500),
                  curve: Easing.legacy,
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation
                   .centerDocked,
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
      ),
    ); /*ChangeNotifierProvider.value(
      value: di.sl<MainScreenState>(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => di.sl<CartCubit>()..loadCart(),
          ),
          BlocProvider<CatalogCubit>(
            create: (context) =>
            di.sl<CatalogCubit>()
              ..getCatalog(),
          ),
        ],
        child: Theme(
          data: ThemeData(
              colorScheme: .fromSeed(seedColor: Colors.yellow),
              useMaterial3: false,
              //fontFamily: 'Custom',
              //fontFamily: 'RobotoCondensed',
              fontFamily: 'RobotoCondensedRegular'
          ),
          child:AutoTabsRouter.builder(
            routes: [
              MenuRoute(),
              CartRoute(),
              ProfileRoute(),
            ],
              builder:(context, children, tabsRouter) {
              return SafeArea(
                child: Scaffold(
                  extendBody: true,
                  appBar: AppBar(title: const Text('Планета суши'),
                    leading:AutoLeadingButton(),
                    automaticallyImplyLeading: true,),
                  // body: MainBody(),
                  body: AnimatedIndexedStack1(
                    index: tabsRouter.activeIndex,
                    children: children,
                    duration: Duration(milliseconds: 500),
                    curve: Easing.legacy,
                  ),
                  floatingActionButtonLocation: FloatingActionButtonLocation
                      .centerDocked,
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
        ),
      ),
    )*/;
  }
}

/* bottomNavigationBar: BottomAppBar(
            color: Colors.orange,
            shape: const CircularNotchedRectangle(),
            notchMargin: 5.0,
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: kBottomNavigationBarHeight,
              child: BottomNavigationBar(
                //selectedFontSize: 0,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.deepPurple,
                currentIndex: _lastIndex,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.black,
                onTap: _selectedTab,
                /*(index) {
                  setState(() {
                    _lastIndex = index;
                  });
                },*/
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: '',
                  ),
                  BottomNavigationBarItem(icon: GestureDetector(
                      onTap: null,
                      child: const SizedBox.shrink()), label: 'Корзина'),
                  const BottomNavigationBarItem(icon: Icon(Icons.abc_sharp), label: ''),
                ],
              ),
            ),
          ),*/
