// internet_bloc.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:weather/bloc/connectivity/connectivity_event.dart';
import 'package:weather/bloc/connectivity/connectivity_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;

  InternetBloc() : super(InternetInitial()) {
    on<CheckInternetEvent>(_onCheckInternetEvent);
    on<ConnectionChangedEvent>(_onConnectionChangedEvent);

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        add(ConnectionChangedEvent(result));
      } as void Function(List<ConnectivityResult> event)?,
    );
  }

  // Event to check connectivity on demand
  Future<void> _onCheckInternetEvent(
      CheckInternetEvent event, Emitter<InternetState> emit) async {
    final result = await _connectivity.checkConnectivity();
    _handleConnectivityResult(result as ConnectivityResult, emit);
  }

  // Event triggered when the connectivity changes
  void _onConnectionChangedEvent(
      ConnectionChangedEvent event, Emitter<InternetState> emit) {
    _handleConnectivityResult(event.connectivityResult, emit);
  }

  // Handle connectivity status change
  void _handleConnectivityResult(
      ConnectivityResult result, Emitter<InternetState> emit) {
    if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
      emit(ConnectedState());
    } else if (result == ConnectivityResult.none) {
      emit(NotConnectedState());
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
