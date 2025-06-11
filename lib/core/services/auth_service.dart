import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gamemate/modules/auth/signup/models/user_model.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_URL_DEV'] ?? '',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

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
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception("Erro ao fazer login: ${e.message}");
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut(); // força seleção de conta
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
      return userCredential;
    } catch (e) {
      throw Exception("Erro ao fazer login com Google: $e");
    }
  }

  /// 🔐 Cria usuário no Firebase e registra no backend
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
      if (user != null) {
        await _registerUserLocally(user: user, username: userModel.username);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception("Erro ao cadastrar: ${e.message}");
    }
  }

  /// 🔐 Registra usuário Google no backend
  Future<void> signupWithGoogle({
    required User user,
    required UserModel userModel,
  }) async {
    try {
      final UserCredential credential = await signInWithGoogle();
      final user = credential.user;

      if (user != null) {
        await _registerUserLocally(user: user, username: userModel.username);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception("Erro ao cadastrar com Google: ${e.message}");
    } catch (e) {
      throw Exception("Erro ao cadastrar com Google: $e");
    }
  }

  /// 🌐 Chamada ao backend para registrar usuário no banco local
  Future<void> _registerUserLocally({
    required User user,
    required String username,
  }) async {
    try {
      final idToken = await user.getIdToken();
      print('🔑 ID Token: $idToken');

      final response = await _dio.post('/auth/register', data: {
        "idToken": idToken,
        "username": username,
      });

      if (response.statusCode == 201) {
        print('✅ Usuário registrado localmente com sucesso: ${response.data}');
      } else {
        print('⚠️ Erro ao registrar usuário localmente: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Erro Dio: ${e.response?.data ?? e.message}');
      rethrow;
    } catch (e) {
      print('❌ Erro inesperado ao registrar usuário localmente: $e');
      rethrow;
    }
  }
}
