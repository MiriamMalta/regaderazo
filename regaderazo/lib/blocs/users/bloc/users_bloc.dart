import 'dart:async';
import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';


import '../../../api/thinkspeak.dart';
import '../../../auth/user_auth_repository.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final ht = APIRepository();
  
  UsersBloc() : super(UsersInitial()) {
    on<UsersEventCreateTo>(_createProfile);
    on<UsersEventDeleteTo>(_deleteProfile);
    on<UsersLoadEvent>(_loadProfiles);
    on<UsersAddTemperatureEvent>(_addTemperature);
    on<UserChangeColorEvent>(_changeColor);
    on<UsersEventGoTo>(_goToProfile);
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
      "admin": event.admin == "" ? null : event.admin,
    };
    print(profile);
    try {
      List<dynamic> document = documents[0]['profiles'];
      print("document: $document");
      for (var i = 0; i < document.length; i++) {
        print(document[i]['name']);
        if (document[i]['name'] == event.profiles) {
          emit(UsersAddedState(profile: "El perfil ya existe"));
          print("HI");
          return;
        }
      }
      emit(UsersAddedState(profile: "Creando perfil")); 
      UsersEventCreateTo(profiles: event.profiles, admin: event.admin);
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
      if (document.indexWhere((element) => element['name'] == event.profile) != -1) {
        emit(UsersAddedTempState(temp: "Agregando temperatura")); 
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
        // SEND TO THINKSPEAK
        await ht.putTemp(event.temperature);
        List<Map<String, dynamic>> allData = await ht.getTemp();  
        print("DATAAA $allData");
        print(temperature);
        // TIMER FOR VÁLVULA
        //bool hora_de_banarse = await _timer(false);
        //bool hora_de_banarse = await _timer(false);
        //print("aaaa: $hora_de_banarse");
        /* Future.delayed(Duration(seconds: 20), () async { //600
          if (hora_de_banarse) {
            print("HORA DE BANARSE");
          }
          else {
            print("NO ES HORA DE BANARSE");
          }
        }); */
        /* int _recordDuration = 600;
        int _current = 0;
        Timer? _timer;
        print("\tRecord duration: $_recordDuration");
        print("\tStarting timer...");
        _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
          Map<String, dynamic> valvula = await ht.getValvula();  
          print("VALVULA ${valvula['field5']}"); //field3
          if (valvula['field5'] == "1"){ //field3
            print("Hora de bañarse");
            hora_de_banarse = true;
            /* final player = AudioPlayer();
            await player.setSource(AssetSource('time.mp3'));
            await Future.delayed(Duration(seconds: 5));
            await player.stop(); */
          }
          _current++;
          print("\t\tTime recorded: $_current");
          if (_current >= _recordDuration || hora_de_banarse) {
            _timer?.cancel();
            _timer = null;
            _current = 0;
            print("\t\tTimer cancelled");
          }
        }); */
        //print(hora_de_banarse);
        /* if (hora_de_banarse == true){
          print("HORAAA");
          emit(DoneState(done: "Ya es hora de bañarse"));
          final player = AudioPlayer();
          await player.setSource(AssetSource('assets/time.mp3'));
          await Future.delayed(Duration(seconds: 5));
          await player.stop();
        } */
        int _recordDuration = 600; //600 = 10 minutos
        int _current = 0;
        bool hora_de_banarse = false;
        Timer? _timer;
        CancelableOperation? _myCancelableFuture;
        print("\tRecord duration: $_recordDuration");
        print("\tStarting timer...");
        _timer = await Timer.periodic(Duration(seconds: 1), (timer) async {
          Map<String, dynamic> valvula = await ht.getValvula();  
          print("VALVULA ${valvula['field3']}"); //field3
          if (valvula['field3'] == "1"){ //field3
            print("Hora de bañarse $hora_de_banarse");
            hora_de_banarse = true;
            final player = AudioPlayer();
            await player.play(AssetSource('time.mp3'));
            await Future.delayed(Duration(seconds: 4));
            await player.stop();
            HapticFeedback.vibrate();
            HapticFeedback.lightImpact();
          }
          _current++;
          print("\t\tTime recorded: $_current");
          if (_current >= _recordDuration || hora_de_banarse) {
            _timer?.cancel();
            _timer = null;
            _current = 0;
            print("\t\tTimer cancelled");
          }
        });
        _myCancelableFuture = CancelableOperation.fromFuture(
          _time(hora_de_banarse),
          onCancel: () { 
            print("CANCELLED");
            emit (DoneState(done: "Ya es hora de bañarse"));
          }
        );
        //emit (DoneState(done: "Ya es hora de bañarse"));
      }
    } 
    catch (e) {
      print(e);
      emit(UsersErrorState(error: "No se pudo agregar la temperatura"));
    }
  }

  Future<bool> _timer(bool hora_de_banarse) async {
    // TIMER FOR VÁLVULA
    int _recordDuration = 600; //600 = 10 minutos
    int _current = 0;
    Timer? _timer;
    print("\tRecord duration: $_recordDuration");
    print("\tStarting timer...");
    CancelableOperation? _myCancelableFuture;
    _myCancelableFuture = CancelableOperation.fromFuture(
      /* Future.delayed(Duration(seconds: 30), () async { //600
        if (hora_de_banarse) {
          print("HORA DE BANARSE");
          /* emit(DoneState(done: "Ya es hora de bañarse"));
          final player = AudioPlayer();
          await player.setSource(AssetSource('assets/time.mp3'));
          await Future.delayed(Duration(seconds: 5));
          await player.stop(); */
        }
        else {
          print("NO ES HORA DE BANARSE");
        }
      } */
      _time(hora_de_banarse),
      onCancel: () => print("Cancelled"),
    );
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      Map<String, dynamic> valvula = await ht.getValvula();  
      print("VALVULA ${valvula['field5']}"); //field3
      if (valvula['field5'] == "1"){ //field3
        print("Hora de bañarse $hora_de_banarse");
        hora_de_banarse = true;
        _myCancelableFuture?.cancel();
        emit (DoneState(done: "Ya es hora de bañarse"));
        final player = AudioPlayer();
        await player.play(AssetSource('time.mp3'));
        await Future.delayed(Duration(seconds: 5));
        await player.stop();
      }
      _current++;
      print("\t\tTime recorded: $_current");
      if (_current >= _recordDuration || hora_de_banarse) {
        _timer?.cancel();
        _timer = null;
        _current = 0;
        print("\t\tTimer cancelled");
      }
    });
    
    //print("Hora de bañarse $hora_de_banarse");
    return hora_de_banarse;
  }

  Future<bool?> _time(hora_de_banarse) async {
    print(hora_de_banarse);
    await Future.delayed(Duration(seconds: 600), () async { //600 = 10 minutos
      if (hora_de_banarse) {
        print("HORA DE BANARSE $hora_de_banarse");
        /* final player = AudioPlayer();
        await player.play(AssetSource('time.mp3'));
        await Future.delayed(Duration(seconds: 5));
        await player.stop(); */
        return true;
      }
      else {
        print("NO ES HORA DE BANARSE $hora_de_banarse");
        return false;
      }
    });
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

  FutureOr<void> _goToProfile(UsersEventGoTo event, Emitter<UsersState> emit) async {
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
      if (document.indexWhere((element) => element['name'] == event.profile) != -1) {
        emit(UsersGoToState(profile: event.profile));
      }
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
