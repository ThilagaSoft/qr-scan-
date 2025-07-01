import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_pro/bloc/auth/auth_bloc.dart';
import 'package:map_pro/bloc/auth/passwordVisibilityCubit.dart';
import 'package:map_pro/bloc/navigation/nav_bloc.dart';
import 'package:map_pro/bloc/navigation/nav_state.dart';
import 'package:map_pro/controller/auth_controller.dart';
import 'package:map_pro/controller/home_controller.dart';
import 'package:map_pro/utility/config/static_text.dart';
import 'package:map_pro/view/chat/chat_page.dart';
import 'package:map_pro/view/home/home_screen.dart';
import 'package:map_pro/view/language/language_screen.dart';
import 'package:map_pro/view/location/map_screen.dart';
import 'package:map_pro/view/profile/profile_screen.dart';
import 'package:map_pro/view/widgets/common_appBar.dart';
import 'package:map_pro/view/widgets/common_bottom_nav.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async
      {
        return false;
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: BlocBuilder<NavigationBloc, NavigationState>(builder: (context, state)
        {
          int currentIndex = 0;
          if (state is NavigationItemChanged)
          {
            currentIndex = state.index;
          }

          return Center(
            child: Scaffold(
              backgroundColor: Colors.grey.shade200,
              appBar: CommonAppBar(title: StaticText.welcome, backButton: false,),
              body: IndexedStack(
                index: currentIndex,
                children:
                [
                  const HomeScreen(),
                  const MapScreen(),
                  const LanguageScreen(),
                  // const ChatPage(),
                 const ProfileScreen(

                  ),

                ],
              ),
            bottomNavigationBar: const CommonBottomNavBar(),
            ),
          );
        })
      ),
    );
  }
}
