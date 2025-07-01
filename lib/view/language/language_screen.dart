import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:map_pro/bloc/language/language_bloc.dart';
import 'package:map_pro/bloc/language/language_event.dart';
import 'package:map_pro/bloc/language/language_state.dart';
import 'package:map_pro/controller/language_controller.dart';
import 'package:map_pro/repository/language_reository.dart';
import 'package:map_pro/utility/common_extension.dart';
import 'package:map_pro/utility/config/static_text.dart';
import 'package:map_pro/utility/theme/app_color.dart';
import 'package:map_pro/view/widgets/button_widget.dart';
import 'package:map_pro/bloc/navigation/nav_bloc.dart';
import 'package:map_pro/bloc/navigation/nav_event.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.currentLocale;

    return BlocProvider(
      create: (_) => LanguageBloc(LanguageController(LanguageRepository()))
        ..add(LoadLanguages()),
      child: Scaffold(
        appBar: AppBar(title: Text(StaticText.selectLanguage.tr())),
        body: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state)
          {
            if (state.isLoading)
            {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null)
            {
              return Center(child: Text('Error: ${state.error}'));
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children:
                [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.languages.length,
                    itemBuilder: (context, index)
                    {
                      final lang = state.languages[index];
                      final isSelected = currentLocale.languageCode == lang.code;
                      return ListTile(
                        title: Text(
                          lang.name,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.black,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check, color: AppColors.primary)
                            : null,
                        onTap: () {
                          context.setLocale(Locale(lang.code));
                          context.read<LanguageBloc>().add(SelectLanguage(lang));
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    child: ButtonWidget(
                      buttonText: StaticText.submit.tr(),
                      onSubmit: ()
                      {
                        context.read<NavigationBloc>().add(NavigationItemSelected(0));
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
