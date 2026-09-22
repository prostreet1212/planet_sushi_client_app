abstract class AuthStatusState {}

class AuthStatusUnknown extends AuthStatusState {}

class AuthStatusChecking extends AuthStatusState {}

class AuthStatusAuthorized extends AuthStatusState {}

class AuthStatusIncomplete extends AuthStatusState {}

class AuthStatusUnauthorized extends AuthStatusState {}