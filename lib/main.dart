import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

import './common/common_context.dart';
import './models/models.dart';
import './navigation/root.dart';
import './reducers/reducers.dart';

bool enableDevicePreview = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final persistor = Persistor<AppState>(
    debug: true,
    storage: FlutterStorage(),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
  );

  var initialState;
  try {
    initialState = await persistor.load();
  } on Exception {
    initialState = AppState.initial();
  }

  final store = Store<AppState>(
    appReducer,
    initialState: initialState,
    middleware: [
      persistor.createMiddleware(),
      LoggingMiddleware.printer()
    ],
  );
  
  runApp(
    StoreProvider(
      store: store,
      child: DevicePreview(
        enabled: enableDevicePreview,
        areSettingsEnabled: true,  
        builder: app
      )
    )
  );
}

MaterialApp app(context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(	
      primaryColor: ThemeColors.primary,	
      accentColor: ThemeColors.accent,	
    ),
    home: Root()
  );
}