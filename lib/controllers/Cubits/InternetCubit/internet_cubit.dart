import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:xeats/controllers/Cubits/InternetCubit/internet_states.dart';
import 'package:xeats/core/Constants/constants.dart';

class InternetCubit extends Cubit<InternetStates> {
  InternetCubit() : super(SuperInternetState());
  static InternetCubit get(context) => BlocProvider.of(context);

  StreamSubscription? _subscription;
  bool hasConnection = false;

  void connected() {
    emit(ConnectedState());
  }

  void notConnected() {
    emit(NotConnectedState(AppConstants.checkConnection));
  }

  void checkConnection() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          connected();
          Logger().i(result);
        }
      } on SocketException catch (_) {
        notConnected();
        Logger().i(result);
      }
    });
  }

  @override
  Future<void> close() {
    _subscription!.cancel();
    return super.close();
  }
}
