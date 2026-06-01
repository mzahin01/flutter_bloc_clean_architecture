import "package:easy_localization/easy_localization.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:hydrated_bloc/hydrated_bloc.dart";
import "package:path_provider/path_provider.dart";

import "firebase_options.dart";
import "src/app.dart";
import "src/configs/adapter/adapter_conf.dart";
import "src/configs/injector/injector_conf.dart";
import "src/core/constants/list_translation_locale.dart";
import "src/core/utils/observer.dart";

//Test
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Future.wait([
    () async {
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } catch (e) {
        debugPrint("Firebase.initializeApp failed: $e");
      }
    }(),
    Hive.initFlutter(),
    () async {
      final storageDirectory = kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory();
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: storageDirectory,
      );
    }(),
  ]);

  configureAdapter();

  configureDepedencies();

  Bloc.observer = AppBlocObserver();

  runApp(
    EasyLocalization(
      supportedLocales: const [indonesiaLocale, englishLocale],
      path: "assets/translations",
      startLocale: englishLocale,
      child: const MyApp(),
    ),
  );
}
