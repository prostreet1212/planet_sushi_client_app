import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/cart/presentation/cubits/cart_cubit.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/providers/main_screen_state.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/widgets/main_body.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/widgets/main_nav_bar.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/widgets/main_nav_fab.dart';
import 'package:planet_sushi_client_app/features/shop/presentation/cubits/catalog_cubit/catalog_cubit.dart';
import 'package:provider/provider.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Строитель мэйнскрин');
    return ChangeNotifierProvider.value(
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
          child: SafeArea(
            child: Scaffold(
              extendBody: true,
              appBar: AppBar(title: const Text('Планета суши')),
              body: const MainBody(),
              floatingActionButtonLocation: FloatingActionButtonLocation
                  .centerDocked,
              floatingActionButton: const MainNavFab(),
              bottomNavigationBar: const MainNavBar(),
            ),
          ),
        ),
      ),
    );
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
