import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../auth/user_auth_repository.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersInitial()) {
    on<UsersEventCreateTo>(_createProfile);
    on<UsersEventDeleteTo>(_deleteProfile);
    on<UsersLoadEvent>(_loadProfiles);
    on<UsersAddTemperatureEvent>(_addTemperature);
    on<UserChangeColorEvent>(_changeColor);
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
      "lastTemperature": null,
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

  FutureOr<void> _addTemperature(UsersAddTemperatureEvent event, Emitter<UsersState> emit) async {
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
    Map<String, dynamic> temperature = {
      "temperature": event.temperature,
      "date": DateTime.now().toString(),
      
    };
    print(temperature);
    await FirebaseFirestore.instance
      .collection('profile')
      .doc(useruid)
      .update({
        'temperature': event.temperature,
      });
    try {
      List<dynamic> document = documents[0]['profiles'];
      //print("document: $document");
      if (document.indexWhere((element) => element['name'] == event.profile) != -1) {
        //var index = document.indexWhere((element) => element['name'] == event.profile);
        //print(document.indexWhere((element) => element['name'] == event.profile));
        emit(UsersAddedTempState(temp: "Agregando temperatura")); 
        /* await FirebaseFirestore.instance
        .collection('profile/$useruid/profiles/$index')
        .add(temperature); */
        print('\x1B[32m${document}\x1B[0m');
        document[document.indexWhere((element) => element['name'] == event.profile)]['lastTemperature'] = event.temperature;
        print('\x1B[32m${document}\x1B[0m');
        await FirebaseFirestore.instance
          .collection('profile')
          .doc(useruid)
          .set({
            'profiles': document,
          }, SetOptions(merge: true));
        await FirebaseFirestore.instance
          .collection('profile')
          .doc(useruid)
          .collection(event.profile)
          .doc('temperatures')
          .set({
            'temperatures': FieldValue.arrayUnion([temperature]),
          }, SetOptions(merge: true));
        await FirebaseFirestore.instance
          .collection('profile')
          .doc(useruid)
          .update({
            'temperature_list': FieldValue.arrayUnion([temperature]),
          });
        emit(UsersAddState(profiles: document));
        /* final QuerySnapshot res = await FirebaseFirestore.instance
          .collection('profile')
          .doc(useruid)
          .collection('$index')
          .get();
        print("TEMP FROM DOC");
        for (var i = 0; i < res.docs.length; i++) {
          print(res.docs[i].data());
        } */
          // .collection('profile/$useruid/profiles/$index/temperature')
          // .add(temperature as Map<String, dynamic>);
          /* .collection('profile')
          .doc(useruid)
          .set({
            'profiles/$index/temperature': FieldValue.arrayUnion([temperature]),
          }, SetOptions(merge: true)); */     
        print(temperature);
      }
    } 
    catch (e) {
      print(e);
      emit(UsersErrorState(error: "No se pudo agregar la temperatura"));
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

  FutureOr<void> _changeColor(UserChangeColorEvent event, Emitter<UsersState> emit) async{
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
      print("document: $document");
      if (document.indexWhere((element) => element['name'] == event.profile) != -1) {
        emit(UsersAddedTempState(temp: "Cambiando color")); 
        print('\x1B[32m${document}\x1B[0m');
        document[document.indexWhere((element) => element['name'] == event.profile)]['color'] = event.color;
        print('\x1B[32m${document}\x1B[0m');
        await FirebaseFirestore.instance
          .collection('profile')
          .doc(useruid)
          .set({
            'profiles': document,
          }, SetOptions(merge: true));
        print(event.color);
        emit(UsersAddState(profiles: document));
      }
    } 
    catch (e) {
      print(e);
      emit(UsersErrorState(error: "No se pudo cambiar el color"));
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
