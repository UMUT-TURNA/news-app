import 'package:go_router/go_router.dart';
import 'package:news/screens/initial_screen.dart';

import '../screens/static_screens/about_screen.dart';
import '../screens/static_screens/contact_screen.dart';
import '../screens/static_screens/settings_screen.dart';
import '../screens/user/change_password_screen.dart';
import '../screens/user/ticket_screen.dart';
import '../screens/user/ticketlist_screen.dart';
import '../screens/user/forget_password_screen.dart';
import '../screens/user/home_screen.dart';
import '../screens/user/login_screen.dart';
import '../screens/user/profile_screen.dart';
import '../screens/user/register_screen.dart';
import '../screens/user/welcome_screen.dart';

final routes = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => InitialScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => WelcomeScreen(),
    ),
    GoRoute(
      path: '/ticket',
      builder: (context, state) => TicketScreen(),
    ),
    GoRoute(
      path: '/ticketlist',
      builder: (context, state) => TicketListPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => AboutScreen(),
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) => ContactScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsScreen(),
    ),
    //user
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfileScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/change_password',
      builder: (context, state) => ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/forget_password',
      builder: (context, state) => ForgetPasswordScreen(),
    ),
  ],
);
