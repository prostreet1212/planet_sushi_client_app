import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{

  @override
  List<Object> get props =>[];
}

class ServerFailure extends Failure{
  final String error;

  ServerFailure({required this.error});
}
class CacheFailure extends Failure{
  final String error;

  CacheFailure({required this.error});
}