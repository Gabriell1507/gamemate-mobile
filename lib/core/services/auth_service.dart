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
      connectTimeout:
          const Duration(seconds: 10), // Timeout menor para evitar travar
      receiveTimeout: const Duration(seconds: 10),
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
      print('[${DateTime.now()}] Iniciando signOut');
      await GoogleSignIn().signOut();
      await _auth.signOut();
      _currentUser.value = null;
      print('[${DateTime.now()}] SignOut concluído');
    } catch (e) {
      print('[${DateTime.now()}] Erro no signOut: $e');
      throw Exception("Erro ao sair: $e");
    }
  }

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('[${DateTime.now()}] Tentando login com email e senha');
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      print('[${DateTime.now()}] Login com email concluído');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('[${DateTime.now()}] Erro no login email/senha: ${e.message}');
      throw Exception(e.message ?? "Erro ao fazer login.");
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      print('[${DateTime.now()}] Iniciando login com Google');
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // NÃO REMOVER O SIGNOUT FORÇADO, ele causa lentidão:
      // await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print('[${DateTime.now()}] Login com Google cancelado pelo usuário');
        throw Exception('Login cancelado pelo usuário');
      }
      print('[${DateTime.now()}] Google user obtido: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('[${DateTime.now()}] Google authentication obtida');

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      print('[${DateTime.now()}] Login Firebase via Google concluído');

      return userCredential;
    } catch (e) {
      print('[${DateTime.now()}] Erro no login com Google: $e');
      throw Exception("Erro ao fazer login com Google: $e");
    }
  }

  Future<void> signupWithEmail({
    required String email,
    required String password,
    required UserModel userModel,
  }) async {
    try {
      print('[${DateTime.now()}] Iniciando cadastro com email');
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        print(
            '[${DateTime.now()}] Usuário Firebase criado, registrando no backend...');
        await _registerUserLocally(user: user, username: userModel.username);
      }
      print('[${DateTime.now()}] Cadastro com email concluído');
    } on FirebaseAuthException catch (e) {
      print(
          '[${DateTime.now()}] Erro no cadastro com email: ${e.code} - ${e.message}');
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
      print('[${DateTime.now()}] Iniciando cadastro com Google');
      final idToken = await user.getIdToken();

      try {
        final response = await _dio.get(
          '/users/me',
          options: Options(headers: {'Authorization': 'Bearer $idToken'}),
        );

        if (response.statusCode == 200) {
          print('[${DateTime.now()}] Usuário já existe no backend.');
          return;
        }
      } on DioException catch (e) {
        if (e.response?.statusCode != 404) {
          print(
              '[${DateTime.now()}] Erro inesperado ao verificar usuário no backend: ${e.response?.statusCode}');
          rethrow;
        }
      }

      await _registerUserLocally(user: user, username: userModel.username);
      print('[${DateTime.now()}] Cadastro com Google concluído');
    } catch (e) {
      print('[${DateTime.now()}] Erro no cadastro com Google: $e');
      throw Exception("Erro ao cadastrar com Google: $e");
    }
  }

  Future<void> _registerUserLocally({
    required User user,
    required String username,
  }) async {
    try {
      print('[${DateTime.now()}] Registrando usuário no backend local');
      final idToken = await user.getIdToken();

      final response = await _dio.post('/auth/register', data: {
        "idToken": idToken,
        "username": username,
      });

      if (response.statusCode == 201) {
        print(
            '[${DateTime.now()}] Usuário registrado localmente: ${response.data}');
      } else {
        print(
            '[${DateTime.now()}] Resposta inesperada do backend: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        print('[${DateTime.now()}] Usuário já existe no backend.');
        return;
      }
      print('[${DateTime.now()}] Erro ao registrar usuário localmente: $e');
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    try {
      isLoading(true);
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não está logado.');
      }

      final idToken = await user.getIdToken();

      // 1️⃣ Chama backend para excluir dados no banco
      await _dio.delete(
        '/users/me',
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      // 2️⃣ Exclui a conta do Firebase
      await user.delete();

      // 3️⃣ Logout local
      await signOut();

      // 4️⃣ Navega para a tela de login
      Get.offAllNamed('/login');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // Recomendar reautenticação e repetir processo
        throw Exception('Reautenticação necessária para excluir conta.');
      } else {
        throw Exception(e.message ?? 'Erro ao excluir conta.');
      }
    } catch (e) {
      throw Exception('Erro ao excluir conta: $e');
    } finally {
      isLoading(false);
    }
  }
}
