import 'package:firebase_auth/firebase_auth.dart';
import 'package:gamemate/modules/auth/signup/models/user_model.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Firestore desabilitado
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rx<User?> _currentUser = Rx<User?>(null);
  User? get currentUser => _currentUser.value;

  @override
  void onInit() {
    super.onInit();
    _currentUser.bindStream(_auth.authStateChanges());
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _currentUser.value = null;
    } catch (e) {
      throw Exception("Erro ao sair: $e");
    }
  }

  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
      _currentUser.value = _auth.currentUser;
    } catch (e) {
      throw Exception("Erro ao atualizar o usuário: $e");
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      throw Exception("Erro ao enviar e-mail de recuperação: $e");
    }
  }

  Future<void> deleteUser() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        // Firestore desabilitado, então removi a exclusão do documento no Firestore
        // await _firestore.collection('users').doc(uid).delete();
        await user.delete();
      } else {
        throw Exception("Usuário não autenticado.");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw FirebaseAuthException(
          code: e.code,
          message: "Reautenticação necessária. Por favor, faça login novamente.",
        );
      } else {
        throw FirebaseAuthException(
          code: e.code,
          message: "Erro ao excluir o usuário: ${e.message}",
        );
      }
    } catch (e) {
      throw Exception("Erro ao excluir o usuário: $e");
    }
  }

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final User? user = userCredential.user;

      // Firestore desabilitado, removi as operações de consulta e criação no Firestore
      /*
      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email ?? '',
            'name': user.displayName ?? '',
            'photoURL': user.photoURL ?? '',
            'createdAt': FieldValue.serverTimestamp(),
            'signInMethod': 'email',
          });
        }
      }
      */

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception("Erro ao fazer login: ${e.message}");
    }
  }

  Future<UserCredential> signInWithGoogle() async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut(); // força a escolha da conta
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception('Login cancelado pelo usuário');
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);

    final User? user = userCredential.user;
    if (user != null) {
      // final userDoc = await _firestore.collection('users').doc(user.uid).get();
      // if (!userDoc.exists) {
      //   await _firestore.collection('users').doc(user.uid).set({
      //     'email': user.email ?? '',
      //     'name': user.displayName ?? '',
      //     'photoURL': user.photoURL ?? '',
      //     'createdAt': FieldValue.serverTimestamp(),
      //     'signInMethod': 'google',
      //   });
      // }
    }

    return userCredential;
  } catch (e) {
    throw Exception("Erro ao fazer login com Google: $e");
  }
}


  Future<void> signupWithEmail({
    required String email,
    required String password,
    required UserModel userModel,
  }) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final User? user = userCredential.user;

      // Firestore desabilitado, removi a criação do documento
      /*
      if (user != null) {
        final updatedUserModel = userModel.copyWith(uid: user.uid);
        await _firestore.collection('users').doc(user.uid).set(updatedUserModel.toJson());
      }
      */
    } on FirebaseAuthException catch (e) {
      throw Exception("Erro ao cadastrar: ${e.message}");
    }
  }

  Future<void> signupWithGoogle({
    required User user,
    required UserModel userModel,
  }) async {
    try {
      // Firestore desabilitado, removi a criação do documento
      /*
      final updatedUserModel = userModel.copyWith(uid: user.uid);
      await _firestore.collection('users').doc(user.uid).set(updatedUserModel.toJson());
      */
    } on FirebaseAuthException catch (e) {
      throw Exception("Erro ao cadastrar com Google: ${e.message}");
    } catch (e) {
      throw Exception("Erro ao cadastrar com Google: $e");
    }
  }
}
