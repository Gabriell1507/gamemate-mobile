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
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  final Rx<User?> _currentUser = Rx<User?>(null);
  User? get currentUser => _currentUser.value;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _currentUser.bindStream(_auth.authStateChanges());
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
      _currentUser.value = null;
    } catch (e) {
      throw Exception("Erro ao sair: $e");
    }
  }

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Erro ao fazer login.");
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Login cancelado pelo usuário');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
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
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        await _registerUserLocally(user: user, username: userModel.username);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception("Email já cadastrado. Faça login para continuar.");
      } else {
        throw Exception(e.message ?? "Erro ao cadastrar.");
      }
    }
  }

  Future<void> signupWithGoogle({
    required User user,
    required UserModel userModel,
  }) async {
    try {
      final idToken = await user.getIdToken();

      try {
        final response = await _dio.get(
          '/users/me',
          options: Options(headers: {'Authorization': 'Bearer $idToken'}),
        );

        if (response.statusCode == 200) {
          print('Usuário já existe no backend.');
          return;
        }
      } on DioException catch (e) {
        if (e.response?.statusCode != 404) {
          rethrow;
        }
      }

      await _registerUserLocally(user: user, username: userModel.username);
    } catch (e) {
      throw Exception("Erro ao cadastrar com Google: $e");
    }
  }

  Future<void> _registerUserLocally({
    required User user,
    required String username,
  }) async {
    try {
      final idToken = await user.getIdToken();

      final response = await _dio.post('/auth/register', data: {
        "idToken": idToken,
        "username": username,
      });

      if (response.statusCode == 201) {
        print('Usuário registrado localmente: ${response.data}');
      } else {
        print('Resposta inesperada: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        print('Usuário já existe no backend.');
        return;
      }
      rethrow;
    }
  }
  Future<void> deleteAccount() async {
  // try {
  //   isLoading(true);
  //   print('Iniciando exclusão da conta...');

  //   final user = _auth.currentUser;
  //   if (user == null) {
  //     print('Nenhum usuário logado encontrado.');
  //     Get.snackbar('Erro', 'Usuário não está logado.');
  //     return;
  //   }

  //   await user.delete();
  //   print('Conta deletada com sucesso.');

  //   await signOut();
  //   print('Usuário deslogado com sucesso.');

  //   Get.offAllNamed('/login'); // ajuste a rota conforme seu app
  //   print('Navegando para a tela de login.');
  // } on FirebaseAuthException catch (e) {
  //   print('Erro ao tentar deletar conta: [${e.code}] ${e.message}');
  //   if (e.code == 'requires-recent-login') {
  //     print('Tentando reautenticar via Google Sign-In...');

  //     try {
  //       final googleUser = await GoogleSignIn().signIn();
  //       if (googleUser == null) {
  //         Get.snackbar('Erro', 'Reautenticação cancelada pelo usuário.');
  //         return;
  //       }

  //       final googleAuth = await googleUser.authentication;
  //       final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );

  //       await _auth.currentUser?.reauthenticateWithCredential(credential);
  //       print('Reautenticação via Google concluída. Tentando excluir novamente...');
        
  //       await deleteAccount(); // tenta deletar novamente após reautenticar
  //     } catch (reauthError) {
  //       print('Erro na reautenticação: $reauthError');
  //       Get.snackbar('Erro', 'Falha na reautenticação. Por favor, faça login novamente.');
  //     }
  //   } else {
  //     Get.snackbar('Erro', e.message ?? 'Erro ao excluir conta');
  //   }
  // } catch (e) {
  //   print('Erro inesperado ao deletar conta: $e');
  //   Get.snackbar('Erro', 'Erro inesperado ao excluir conta');
  // } finally {
  //   isLoading(false);
  //   print('Processo de exclusão finalizado.');
  // }
}

}
