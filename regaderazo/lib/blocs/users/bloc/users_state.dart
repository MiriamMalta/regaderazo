part of 'users_bloc.dart';

@immutable
abstract class UsersState {
  const UsersState();

  @override
  List<Object> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoadingState extends UsersState {}

class UsersAddState extends UsersState {
  final List<dynamic> profiles;

  UsersAddState({required this.profiles});

  @override
  List<Object> get props => [profiles];
}

class UsersAddedState extends UsersState {
  final String profile;

  UsersAddedState({required this.profile});

  @override
  List<Object> get props => [profile];
}

class UsersAddedTempState extends UsersState {
  final String temp;

  UsersAddedTempState({required this.temp});

  @override
  List<Object> get props => [temp];
}

class UsersErrorState extends UsersState {
  final String error;

  UsersErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
