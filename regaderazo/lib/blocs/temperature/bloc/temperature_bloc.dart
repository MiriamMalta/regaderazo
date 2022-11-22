import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../auth/user_auth_repository.dart';

part 'temperature_event.dart';
part 'temperature_state.dart';

class TemperatureBloc extends Bloc<TemperatureEvent, TemperatureState> {
  TemperatureBloc() : super(TemperatureInitial()) {
    on<TemperatureGetEvent>(_loadTemperatures);
  }

  FutureOr<void> _loadTemperatures(TemperatureGetEvent event, Emitter<TemperatureState>emit) async {
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
      emit(TempErrorState(error: "Usuario no encontrado"));
      return;
    }
    try {
      List<dynamic> document = documents[0]['profiles'];
      print("document: $document");
      if (document.indexWhere((element) => element['name'] == event.profile) != -1) {
        var index = document.indexWhere((element) => element['name'] == event.profile);
        print(document.indexWhere((element) => element['name'] == event.profile));
        emit(TempLoadingState(temp: "Cargando temperatura")); 
        final QuerySnapshot res = await FirebaseFirestore.instance
          .collection('profile')
          .doc(useruid)
          .collection('$index')
          .get();
        emit(TempChartState(temp: res.docs));
        print('\x1B[33mPRINT FROM BLOC\x1B[0m');
        for (var i = 0; i < res.docs.length; i++) {
          print(res.docs[i].data());
        }
      }
    } 
    catch (e) {
      print(e);
      emit(TempErrorState(error: "No se pudo cargar la temperatura"));
    }
  }

  /*
  FutureOr<void> _loadTemperatures(UsersLoadTemperatureEvent event, Emitter<UsersState> emit) async {
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
        var index = document.indexWhere((element) => element['name'] == event.profile);
        print(document.indexWhere((element) => element['name'] == event.profile));
        emit(UsersAddedTempState(temp: "Cargando temperatura")); 
        final QuerySnapshot res = await FirebaseFirestore.instance
          .collection('profile')
          .doc(useruid)
          .collection('$index')
          .get();
        emit(TempChartState(temp: res.docs));
        print("TEMP FROM DOC");
        for (var i = 0; i < res.docs.length; i++) {
          print(res.docs[i].data());
        }
      }
    } 
    catch (e) {
      print(e);
      emit(UsersErrorState(error: "No se pudo cargar la temperatura"));
    }
  }*/

  // get temperature from firebase
  getTemperature (String profile) async {
    String useruid = UserAuthRepository.userInstance?.currentUser?.uid ?? "";
    print("User uid: $useruid");
    if (useruid == "") {
      return;
    }
    List<dynamic> document = [];
    final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('profile')
      .where('useruid', isEqualTo: useruid)
      .get();
    print("result: ${result.docs.length}");
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      return [];
    }
    try {
      document = documents[0]['profiles'];
      print("document: $document");
      if (document.indexWhere((element) => element['name'] == profile) != -1) {
        //var index = document.indexWhere((element) => element['name'] == profile);
        print(document.indexWhere((element) => element['name'] == profile));
        List<dynamic> temperatures = [];
        final QuerySnapshot res = await FirebaseFirestore.instance
          .collection('profile')
          .doc(useruid)
          .collection(profile)
          .get();
        print("TEMP FROM DOC");
        for (var i = 0; i < res.docs.length; i++) {
          temperatures.add(res.docs[i].data());
          print(res.docs[i].data());
        }
        return temperatures;
      }
    } 
    catch (e) {
      print(e);
      return [];
    }
    return [];
  }
}
