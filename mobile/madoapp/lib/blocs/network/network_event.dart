import 'package:equatable/equatable.dart';

abstract class NetworkEvent extends Equatable {
  const NetworkEvent();

  @override
  List<Object> get props => [];
}

class SwitchNetwork extends NetworkEvent {}
class InitNetwork extends NetworkEvent {}
