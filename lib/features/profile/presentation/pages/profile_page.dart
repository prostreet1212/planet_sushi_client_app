import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:planet_sushi_client_app/features/auth/data/models/user_model.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_remote_data_source.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('строитель пэйдж3');
    return Container(
      //color: Colors.green,
      child: Center(
        child: ElevatedButton(onPressed: ()async{
          UserModel? user=await di.sl<ProfileRemoteDataSource>().getProfile();
          print(user!.name);
        }, child: const Text('profile')),
      ),
    );
  }
}
