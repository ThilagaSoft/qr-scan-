import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_pro/bloc/auth/auth_bloc.dart';
import 'package:map_pro/bloc/auth/passwordVisibilityCubit.dart';
import 'package:map_pro/bloc/chat/chat_bloc.dart';
import 'package:map_pro/bloc/country/country_bloc.dart';
import 'package:map_pro/controller/auth_controller.dart';
import 'package:map_pro/controller/chat_controller.dart';
import 'package:map_pro/controller/country_controller.dart';
import 'package:map_pro/controller/home_controller.dart';
import 'package:map_pro/controller/initial_controller.dart';
import 'package:map_pro/utility/theme/app_color.dart';
import 'package:map_pro/view/auth/login_screen.dart';
import 'package:map_pro/view/auth/register_screen.dart';
import 'package:map_pro/view/chat/chat_page.dart';
import 'package:map_pro/view/chat/qr_code_generator.dart';
import 'package:map_pro/view/chat/qr_scan_page.dart';
import 'package:map_pro/view/dashboard/dashbard_screen.dart';
import 'package:map_pro/view/home/home_screen.dart';
import 'package:map_pro/view/initial/initial_screen.dart';
import 'package:map_pro/view/language/language_screen.dart';
import 'package:map_pro/view/location/map_screen.dart';
import 'package:map_pro/view/profile/profile_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {

      case '/login':
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: AppColors.primary, // Top status bar
          systemNavigationBarColor: AppColors.primary, // Bottom navigation bar
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
        ));
        return NoPopPageRoute(
          builder: (context) => LoginScreen(
              authController: AuthController(
                authBloc: BlocProvider.of<AuthBloc>(context),
                passwordVisibilityCubit: BlocProvider.of<PasswordVisibilityCubit>(context),
            ),
          ),
        );

      case '/register':

        return NoPopPageRoute(
          builder: (context) => RegisterScreen(
            countryController:CountryController(countryBloc: BlocProvider.of<CountryBloc>(context)),
            authController: AuthController(
              authBloc: BlocProvider.of<AuthBloc>(context),
              passwordVisibilityCubit: BlocProvider.of<PasswordVisibilityCubit>(context),
            ),
          )
        );

      case '/home':

        return MaterialPageRoute(builder: (_) =>  HomeScreen());
      case '/location':

        return MaterialPageRoute(builder: (_) => const MapScreen());

     case '/language':

        return MaterialPageRoute(builder: (_) => const LanguageScreen());
     case '/chat':

        return MaterialPageRoute(builder: (context) =>  ChatPage(
          chatController:ChatController(
            chatBloc: BlocProvider.of<ChatBloc>(context),
          ),
        ));
      // case '/qrcodeGen':
      //
      //   return MaterialPageRoute(builder: (_) =>  QRCodeGenScreen());
      // case '/qrcode':
      //
      //   return MaterialPageRoute(builder: (_) =>  QRScanScreen());
      case '/profile':

        return MaterialPageRoute(builder: (_) =>  ProfileScreen());

      case '/':

        return MaterialPageRoute(builder: (_) => InitScreen(initController: InitController(),));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route')),
          ),
        );
    }
  }
}
class NoPopPageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  NoPopPageRoute({
    required this.builder,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );

  @override
  bool get maintainState => true;

  @override
  bool get opaque => true;

  @override
  bool get barrierDismissible => false;

  @override
  bool get canPop => false; 
}
