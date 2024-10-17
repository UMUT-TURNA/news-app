import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/storage/storage.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(super.initialState);

  changeLanguage(String lang) async {
    final newState = SettingsState(
      language: lang,
      darkMode: state.darkMode,
      userInfo: state.userInfo,
      userLoggedIn: state.userLoggedIn,
    );

    emit(newState);

    final storage = AppStorage();
    await storage.writeAppSettings(
      darkMode: state.darkMode,
      language: lang,
    );
  }

  changeDarkMode(bool darkMode) async {
    final newState = SettingsState(
      language: state.language,
      darkMode: darkMode,
      userInfo: state.userInfo,
      userLoggedIn: state.userLoggedIn,
    );

    emit(newState);

    final storage = AppStorage();
    await storage.writeAppSettings(
      darkMode: darkMode,
      language: state.language,
    );
  }

  userLogin(List<String> userInfo) async {
    final newState = SettingsState(
      language: state.language,
      darkMode: state.darkMode,
      userInfo: userInfo,
      userLoggedIn: true,
    );

    emit(newState);

    final storage = AppStorage();

    await storage.writeUserData(isLoggedIn: true, userInfo: userInfo);
  }

  userLogout() async {
    final newState = SettingsState(
      language: state.language,
      darkMode: state.darkMode,
      userInfo: [],
      userLoggedIn: false,
    );

    emit(newState);

    final storage = AppStorage();

    await storage.writeUserData(isLoggedIn: false, userInfo: []);
  }

  userUpdate(List<String> userInfo) async {
    final newState = SettingsState(
      language: state.language,
      darkMode: state.darkMode,
      userInfo: userInfo,
      userLoggedIn: true,
    );

    emit(newState);
    final storage = AppStorage();

    await storage.writeUserData(isLoggedIn: true, userInfo: userInfo);
  }
}
