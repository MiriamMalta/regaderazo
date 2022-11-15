import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../auth/user_auth_repository.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersInitial()) {
    on<UsersEventCreateTo>(_createProfile);
    on<UsersEventDeleteTo>(_deleteProfile);
    on<UsersLoadEvent>(_loadProfiles);
  }

  FutureOr<void> _createProfile(UsersEventCreateTo event, Emitter<UsersState> emit) async {
    String useruid = UserAuthRepository.userInstance?.currentUser?.uid ?? "";
    print("User uid: $useruid");
    if (useruid == "") {
      return;
    }
    final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('profile')
      .where('useruid', isEqualTo: useruid)
      .get();
    print("result: ${result.docs.length}");
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      emit(UsersErrorState(error: "Usuario no encontrado"));
      return;
    }
    Map profile = {
      "name": event.profiles,
      "color": "0xFF000000",
      "temperature": [],
    };
    print(profile);
    try {
      List<dynamic> document = documents[0]['profiles'];
      print("document: $document");
      /* if(profiles.indexWhere((element) => element['name'] == event.profiles) == -1) {
        profiles.add(profile);
        emit(UsersAddedState(profile: "Creando perfil")); 
      } */
      // checar si el perfil ya existe
      for (var i = 0; i < document.length; i++) {
        print(document[i]['name']);
        if (document[i]['name'] == event.profiles) {
          emit(UsersAddedState(profile: "El perfil ya existe"));
          print("HI");
          return;
        }
      }
      /* else {
        emit(UsersAddedState(profile: "Ya existe ese nombre de perfil"));
      }   */ 
      emit(UsersAddedState(profile: "Creando perfil")); 
      UsersEventCreateTo(profiles: event.profiles);
      await FirebaseFirestore.instance
        .collection('profile')
        .doc(useruid)
        .set({
          'profiles': FieldValue.arrayUnion([profile]),
        }, SetOptions(merge: true));
      emit(UsersAddState(profiles: document));
      print(profile);
    } 
    catch (e) {
      print(e);
      emit(UsersErrorState(error: "No se pudo agregar el perfil"));
    }
  } 

  FutureOr<void> _loadProfiles(UsersLoadEvent event, Emitter<UsersState> emit) async {
    String useruid = UserAuthRepository.userInstance?.currentUser?.uid ?? "";
    print("User uid: $useruid");
    if (useruid == "") {
      return;
    }
    final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('profile')
      .where('useruid', isEqualTo: useruid)
      .get();
    print("result: ${result.docs.length}");
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      emit(UsersErrorState(error: "Usuario no encontrado"));
      return;
    }
    try {
      List<dynamic> document = documents[0]['profiles'];
      emit(UsersAddState(profiles: document));
    } 
    catch (e) {
      emit(UsersErrorState(error: "No se encontrar el perfil"));
    }
  }

  FutureOr<void> _deleteProfile(UsersEventDeleteTo event, Emitter<UsersState> emit) async {
    String useruid = UserAuthRepository.userInstance?.currentUser?.uid ?? "";
    print("User uid: $useruid");
    if (useruid == "") {
      return;
    }
    final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('profile')
      .where('useruid', isEqualTo: useruid)
      .get();
    print("result: ${result.docs.length}");
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      emit(UsersErrorState(error: "Usuario no encontrado"));
      return;
    }
    try {
      List<dynamic> document = documents[0]['profiles'];
      document.removeWhere((element) => element['name'] == event.profiles);
      await FirebaseFirestore.instance
        .collection('profile')
        .doc(useruid)
        .update({
          'profiles': document,
        });
      emit(UsersAddState(profiles: document));
    } 
    catch (e) {
      emit(UsersErrorState(error: "No se pudo eliminar el perfil"));
    }
  }
}
