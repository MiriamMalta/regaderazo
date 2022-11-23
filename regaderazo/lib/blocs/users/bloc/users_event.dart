part of 'users_bloc.dart';

@immutable
abstract class UsersEvent extends Equatable{
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class UsersEventCreateTo extends UsersEvent {
  final String profiles;
  final String admin;

  UsersEventCreateTo({required this.profiles, required this.admin});

  @override
  List<Object> get props => [profiles, admin];
}

class UsersLoadEvent extends UsersEvent {
  final String useruid;

  UsersLoadEvent({required this.useruid});

  @override
  List<Object> get props => [useruid];
}

class UsersAddTemperatureEvent extends UsersEvent {
  final String profile;
  final String temperature;

  UsersAddTemperatureEvent({required this.profile, required this.temperature});

  @override
  List<Object> get props => [profile, temperature];
}

class UserChangeColorEvent extends UsersEvent {
  final String profile;
  final String color;

  UserChangeColorEvent({required this.profile, required this.color});

  @override
  List<Object> get props => [profile, color];
}

class UsersEventDeleteTo extends UsersEvent {
  final String profiles;

  UsersEventDeleteTo({required this.profiles});

  @override
  List<Object> get props => [profiles];
}
