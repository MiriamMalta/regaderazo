part of 'users_bloc.dart';

@immutable
abstract class UsersEvent extends Equatable{
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class UsersEventCreateTo extends UsersEvent {
  final String profiles;

  UsersEventCreateTo({required this.profiles});

  @override
  List<Object> get props => [profiles];
}

class UsersEventDeleteTo extends UsersEvent {
  final String profiles;

  UsersEventDeleteTo({required this.profiles});

  @override
  List<Object> get props => [profiles];
}
