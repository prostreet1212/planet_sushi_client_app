

import 'package:planet_sushi_client_app/features/auth/data/models/user_model.dart';

abstract class ProfileState {}

class ProfileInit extends ProfileState{}
class Profileoading extends ProfileState{}
class ProfileEmpty extends ProfileState{}

class ProfileSuccess extends ProfileState{
  final UserModel user;
  ProfileSuccess({required this.user});


}
class ProfileError extends ProfileState{
  final String message;

  ProfileError({required this.message});

}