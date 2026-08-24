import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/backend_providers.dart';
import '../core/widgets/notifications_page.dart';
import '../features/auth/presentation/forgot_password_page.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/register_page.dart';
import '../core/domain/entities/scanned_card.dart';
import '../features/cards/presentation/add_note_page.dart';
import '../features/cards/presentation/add_reminder_page.dart';
import '../features/cards/presentation/card_detail_page.dart';
import '../features/cards/presentation/cards_page.dart';
import '../features/cards/presentation/scanned_card_edit_page.dart';
import '../features/digital_card/presentation/digital_card_edit_page.dart';
import '../features/groups/presentation/group_cards_page.dart';
import '../features/groups/presentation/groups_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/scanner/presentation/scanner_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../features/tools/presentation/tools_page.dart';
import 'app_shell.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final refreshStream = GoRouterRefreshStream(authRepo.authStateChanges);
  ref.onDispose(refreshStream.dispose);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: refreshStream,
    redirect: (context, state) {
      final isLoggedIn = authRepo.currentUser != null;
      final location = state.matchedLocation;
      final isAuthRoute = location.startsWith('/auth');

      // OAuth deep link callback (com.ndgroup.ndcard://login-callback) geldiğinde
      // GoRouter path olarak '/' görür — doğru sayfaya yönlendir.
      if (location == '/') {
        return isLoggedIn ? '/home' : '/auth/login';
      }

      if (!isLoggedIn && !isAuthRoute) return '/auth/login';
      if (isLoggedIn && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/auth/login', builder: (_, _) => const LoginPage()),
      GoRoute(path: '/auth/register', builder: (_, _) => const RegisterPage()),
      GoRoute(
        path: '/auth/forgot-password',
        builder: (_, _) => const ForgotPasswordPage(),
      ),
      GoRoute(path: '/scan', builder: (_, _) => const ScannerPage()),
      GoRoute(path: '/notifications', builder: (_, _) => const NotificationsPage()),
      GoRoute(
        path: '/digital-card/new',
        builder: (_, _) => const DigitalCardEditPage(),
      ),
      GoRoute(
        path: '/digital-card/edit/:id',
        builder: (_, state) => DigitalCardEditPage(cardId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/scanned-card/edit',
        builder: (_, state) {
          final extra = state.extra;
          return ScannedCardEditPage(initialDraft: extra is ScannedCard ? extra : null);
        },
      ),
      GoRoute(
        path: '/scanned-card/edit/:id',
        builder: (_, state) => ScannedCardEditPage(cardId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/scanned-card/:id',
        builder: (_, state) => CardDetailPage(cardId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/scanned-card/:id/note',
        builder: (_, state) => AddNotePage(
          cardId: state.pathParameters['id']!,
          cardName: state.extra as String?,
        ),
      ),
      GoRoute(
        path: '/scanned-card/:id/reminder',
        builder: (_, state) => AddReminderPage(cardId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/groups', builder: (_, _) => const GroupsPage()),
      GoRoute(
        path: '/groups/smart/:type',
        builder: (_, state) => GroupCardsPage(smartType: state.pathParameters['type']),
      ),
      GoRoute(
        path: '/groups/:id',
        builder: (_, state) => GroupCardsPage(
          groupId: state.pathParameters['id'],
          title: state.extra is String ? state.extra as String : null,
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/home', builder: (_, _) => const HomePage())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/cards', builder: (_, _) => const CardsPage())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/tools', builder: (_, _) => const ToolsPage())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/settings', builder: (_, _) => const SettingsPage())],
          ),
        ],
      ),
    ],
  );
});
