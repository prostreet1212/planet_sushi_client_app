abstract class AddUserState {}

class AddUserInitial extends AddUserState {}
class AddUserSuccess extends AddUserState {}
class AddUserError extends AddUserState {
  final String message;
  AddUserError({required this.message});
}

