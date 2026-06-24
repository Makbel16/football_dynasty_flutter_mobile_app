import 'package:go_router/go_router.dart';
import '../../features/authentication/screens/login_screen.dart';
import '../../features/authentication/screens/register_screen.dart';
import '../../features/authentication/screens/forgot_password_screen.dart';
import '../../features/authentication/screens/splash_screen.dart';
import '../../features/club/screens/club_creation_screen.dart';
import '../../features/dashboard/screens/main_shell_screen.dart';
import '../../features/settings/screens/settings_screen.dart';

class AppRouter {
  AppRouter._();

  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const clubCreation = '/club-creation';
  static const dashboard = '/dashboard';
  static const settings = '/settings';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: clubCreation,
        builder: (context, state) => const ClubCreationScreen(),
      ),
      GoRoute(
        path: dashboard,
        builder: (context, state) => const MainShellScreen(),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
