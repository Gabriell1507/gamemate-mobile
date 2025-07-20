import 'package:gamemate/modules/auth/recovery_password/bindings/recovery_password_binding.dart';
import 'package:gamemate/modules/auth/recovery_password/view/recovery_password_view.dart';
import 'package:gamemate/modules/auth/signin/bindings/login_binding.dart';
import 'package:gamemate/modules/auth/signin/view/login_view.dart';
import 'package:gamemate/modules/auth/signup/bindings/signup_bindings.dart';
import 'package:gamemate/modules/auth/signup/view/signup_view.dart';
import 'package:gamemate/modules/games/bindings/games_binding.dart';
import 'package:gamemate/modules/games/bindings/search_games_result_binding.dart';
import 'package:gamemate/modules/games/controllers/search_games_result_controller.dart';
import 'package:gamemate/modules/games/views/games_view.dart';
import 'package:gamemate/modules/games/views/search_games_results_view.dart';

import 'package:gamemate/modules/games_detail/bindings/game_detail_binding.dart';
import 'package:gamemate/modules/games_detail/view/game_detail_view.dart';
import 'package:gamemate/modules/library/bindings/library_binding.dart';
import 'package:gamemate/modules/library/view/library_view.dart';
import 'package:gamemate/modules/profile/bindings/profile_binding.dart';
import 'package:gamemate/modules/profile/views/profile_page.dart';
import 'package:gamemate/modules/splash/binding/splash_binding.dart';
import 'package:gamemate/modules/splash/view/splash_view.dart';
import 'package:get/get.dart';

class AppRoute {
  static String splash = '/splash';

  //Auth
  static String login = '/login';
  static String register = '/register';
  static String forgotPassword = '/forgot-password';

  //Home
  static String home = '/home';

  static String resultPage = '/result-page';

  static String gameDetail = '/game-detail';

  static String profile = '/profile';

  static String library = '/library';

  static List<GetPage> pages = [
    GetPage(
      binding: SplashBinding(),
      name: splash,
      page: () => const SplashView(),
    ),
    GetPage(
      binding: LoginBinding(),
      name: login,
      page: () => LoginView(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: register,
      page: () => const SignupView(),
      binding: SignupBindings(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: home,
      page: () => GamesView(),
      binding: GamesBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/result-page',
      page: () => SearchResultsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SearchResultsController());
      }),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/game-detail',
      page: () => const GameDetailsView(),
      binding: GameDetailsBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/profile',
      page: () => ProfilePage(),
      binding: ProfileBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/library',
      page: () => const LibraryView(),
      binding: ProfileBinding(),
      transition: Transition.noTransition,
    ),
  ];
}
