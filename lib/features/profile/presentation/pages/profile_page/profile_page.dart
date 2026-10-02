import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/core/routers/app_router.dart';
import 'package:planet_sushi_client_app/features/auth/data/models/user_model.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/cubits/auth_status_cubit/auth_status_cubit.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/cubits/auth_status_cubit/auth_status_state.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_local_data_source.dart';
import 'package:planet_sushi_client_app/features/profile/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:planet_sushi_client_app/features/profile/presentation/cubits/profile_cubit/profile_state.dart';
import 'package:planet_sushi_client_app/features/profile/presentation/pages/profile_page/widgets/login_button.dart';
import 'package:planet_sushi_client_app/features/profile/presentation/pages/profile_page/widgets/profile_card.dart';
import 'package:planet_sushi_client_app/features/profile/presentation/pages/profile_page/widgets/profile_laoding_card.dart';
import 'package:planet_sushi_client_app/features/profile/presentation/pages/profile_page/widgets/profile_menu.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TabsRouter? _tabsRouter;

  @override
  void initState() {
    super.initState();
    // Первичная загрузка профиля после появления страницы.
  /*  WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileCubit>().getLProfile();
      }
    });*/
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Подписываемся на смену активной вкладки, чтобы обновлять профиль
    // при каждом открытии вкладки "Профиль" (например, после регистрации).
 /*   try {
      final TabsRouter tabsRouter = AutoTabsRouter.of(context);
      if (!identical(tabsRouter, _tabsRouter)) {
        _tabsRouter?.removeListener(_onTabChanged);
        _tabsRouter = tabsRouter;
        _tabsRouter!.addListener(_onTabChanged);
      }
    } catch (_) {
      // Страница открыта вне AutoTabsRouter — обновление по вкладкам не нужно.
    }*/
  }

/*  void _onTabChanged() {
    if (!mounted || _tabsRouter == null) return;
    try {
      if (_tabsRouter!.current.name == context.routeData.name) {
        context.read<ProfileCubit>().getLProfile();
      }
    } catch (_) {
      // Контекст вне области RouteData — пропускаем.
    }
  }*/

  @override
  void dispose() {
   // _tabsRouter?.removeListener(_onTabChanged);
    super.dispose();
  }

  Future<void> _logout() async {
    final ProfileState profileState = context.read<ProfileCubit>().state;

    if (di.sl<Supabase>().client.auth.currentUser != null) {
      await di.sl<Supabase>().client.auth.signOut();
    }

    if (profileState is ProfileSuccess) {
      await di.sl<ProfileLocalDataSource>().deleteProfile(profileState.user);
    }

    if (mounted) {
      context.read<ProfileCubit>().getLProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    //был bloclistener
    return BlocConsumer<AuthStatusCubit, AuthStatusState>(
      // При любом изменении статуса авторизации перечитываем профиль.
      listener: (context, authState) {
        context.read<ProfileCubit>().getLProfile();
      },
      builder: (context,authState){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, profileState) {
              /*final bool isAuthorized =
                  di.sl<Supabase>().client.auth.currentUser != null;
              final UserModel? user =
              profileState is ProfileSuccess ? profileState.user : null;
              final bool hasName = user != null &&
                  user.name != null &&
                  user.name!.trim().isNotEmpty;
              final bool showProfile = isAuthorized && user != null && hasName;*/

              final UserModel? user =
              profileState is ProfileSuccess ? profileState.user : null;
              //final bool showProfile=authState is AuthStatusAuthorized&& user!=null;
              final bool isAuthorized=authState is AuthStatusAuthorized&& user!=null;
              final Widget header;
              if (/*showProfile*/isAuthorized) {
                header = ProfileCard(user: user);
              } else if (isAuthorized &&
                  (profileState is ProfileLoading ||
                      profileState is ProfileInit)) {
                header = const ProfileLoadingCard();
              } else {
                header = LoginButton(
                  onPressed: () => context.router.push(const LoginRoute()),
                );
              }

              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  header,
                  const SizedBox(height: 16),
                  ProfileMenu(onLogout: _logout),
                ],
              );
            },
          ),
        );

      }
    );
  }
}














