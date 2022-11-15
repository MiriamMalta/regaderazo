import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersInitial()) {
    on<UsersEventCreateTo>(_createProfile);
    on<UsersEventDeleteTo>(_deleteProfile);
  }

  List<dynamic> profiles = [];

  FutureOr<void> _createProfile(UsersEventCreateTo event, Emitter<UsersState> emit) {
    Map profile = {
      "name": event.profiles,
    };
    try {
      print(profiles.indexWhere((element) => element['name'] == event.profiles));
      if(profiles.indexWhere((element) => element['name'] == event.profiles) == -1) {
        profiles.add(profile);
        emit(UsersAddedState(profile: "Creando perfil")); 
      }
      else {
        emit(UsersAddedState(profile: "Ya existe ese nombre de perfil"));
      }   
      UsersEventCreateTo(profiles: event.profiles);
      emit(UsersAddState(profiles: profiles));
      print(profiles);
    } 
    catch (e) {
      emit(UsersErrorState(error: "No se pudo agregar el perfil"));
    }
  } 

  FutureOr<void> _deleteProfile (UsersEventDeleteTo event, Emitter<UsersState> emit) {
    
  }
}
