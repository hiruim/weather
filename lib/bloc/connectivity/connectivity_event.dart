// connectivity_event.dart

import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class InternetEvent extends Equatable {
  const InternetEvent();

  @override
  List<Object?> get props => [];
}

class CheckInternetEvent extends InternetEvent {
  const CheckInternetEvent();
}

class ConnectionChangedEvent extends InternetEvent {
  final ConnectivityResult connectivityResult;

  const ConnectionChangedEvent(this.connectivityResult);

  @override
  List<Object?> get props => [connectivityResult];
}
