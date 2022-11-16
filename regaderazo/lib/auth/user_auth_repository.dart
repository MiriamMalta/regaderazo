import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email", "profile"]);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static FirebaseAuth? userInstance = null;

  UserAuthRepository() {
    userInstance = _auth;
  }

  FirebaseAuth getInstance() {
    return _auth;
  }

  String? getuid() {
    print('\x1B[32mcurrent user: ${_auth.currentUser}');
    return _auth.currentUser?.uid;
  }
  
  bool isAlreadyAuthenticated() {
    return _auth.currentUser != null;
  }

  Future<void> signOutGoogleUser() async {
    await _googleSignIn.signOut();
  }

  Future<void> signOutFirebaseUser() async {
    await _auth.signOut();
  }

  Future<void> signOutFull() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> signInWithGoogle() async {
    //Google sign in
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;

    print(">> User email:${googleUser.email}");
    print(">> User name:${googleUser.displayName}");
    print(">> User photo:${googleUser.photoUrl}");

    // credenciales de usuario autenticado con Google
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // firebase sign in con credenciales de Google
    final authResult = await _auth.signInWithCredential(credential);

    final user = authResult.user;

    if (user != null) {
      final User? currentUser = _auth.currentUser;
      assert(user.uid == currentUser!.uid);

      // crear tabla user en firebase cloudFirestore y agregar valor profiles []
      await _createUserCollectionFirebase(_auth.currentUser!);
    }
  }

  Future<void> _createUserCollectionFirebase(User user) async {
    var userDoc =
      await FirebaseFirestore.instance.collection("user").doc(user.uid).get();
    // Si no exite el doc, lo crea con valor default lista vacia
    if (!userDoc.exists) {
      await FirebaseFirestore.instance.collection("user").doc(user.uid).set({
        'id': user.uid,
        'username': user.displayName,
        'profilePicture': user.photoURL,
        'email': user.email,
        'phoneNumber': user.phoneNumber,
        'isAdministrator': false,
      });
      await FirebaseFirestore.instance.collection("profile").doc(user.uid).set(
        {
          'useruid': user.uid,
          'profiles': [],
          'temperature': null
        },
      );
    } else {
      // Si ya existe el doc return
      return;
    }
  }

  signOut() {}
}
