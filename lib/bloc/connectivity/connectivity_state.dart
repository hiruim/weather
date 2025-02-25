// connectivity_state.dart

import 'package:equatable/equatable.dart';

abstract class InternetState extends Equatable {
  const InternetState();

  @override
  List<Object?> get props => [];
}

class InternetInitial extends InternetState {}

class ConnectedState extends InternetState {}

class NotConnectedState extends InternetState {}
