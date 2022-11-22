part of 'users_bloc.dart';

abstract class UsersEvent{
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

class UsersLoadTemperatureEvent extends UsersEvent {
  final String profile;

  UsersLoadTemperatureEvent({required this.profile});

  @override
  List<Object> get props => [profile];
}

class UsersEventDeleteTo extends UsersEvent {
  final String profiles;

  UsersEventDeleteTo({required this.profiles});

  @override
  List<Object> get props => [profiles];
}
