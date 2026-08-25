import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/auth/data/models/user_model.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_local_data_source.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_remote_data_source.dart';
import 'package:planet_sushi_client_app/features/profile/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:planet_sushi_client_app/features/profile/presentation/cubits/profile_cubit/profile_state.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('строитель пэйдж3');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          BlocBuilder<ProfileCubit,ProfileState>(
              builder: (context,profileState){
            return Container();
          }),
          Container(
            //color: Colors.green,
            child: Center(
              child: ElevatedButton(onPressed: ()async{
               /* UserModel? user=await di.sl<ProfileRemoteDataSource>().getProfile();
                print(user!.name);*/
               /* UserModel userModel=UserModel(phone: '+79532602744', name: 'gosha',id: 'aaa');
                di.sl<ProfileLocalDataSource>().deleteCProfile(userModel);*/

                di.sl<Supabase>().client.auth.signOut();

              }, child: const Text('profile')),
            ),
          ),
        ],
      ),
    );
  }
}
