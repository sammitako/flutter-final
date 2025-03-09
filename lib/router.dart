import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_final/providers.dart';
import 'package:tiktok_final/views/auth/sign_in_screen.dart';
import 'package:tiktok_final/views/auth/sign_up_screen.dart';
import 'package:tiktok_final/views/home/home_screen.dart';
import 'package:tiktok_final/views/post/post_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/signin',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == '/signin' ||
          state.matchedLocation == '/signup';

      // If coming from sign-up screen to sign-in screen, allow it regardless of auth state
      final isFromSignUpToSignIn = state.matchedLocation == '/signin' &&
          state.uri.queryParameters['from'] == 'signup';

      if (!isLoggedIn && !isAuthRoute) {
        return '/signin';
      }

      if (isLoggedIn && isAuthRoute && !isFromSignUpToSignIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/post',
        builder: (context, state) => const PostScreen(),
      ),
    ],
  );
});
