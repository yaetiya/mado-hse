import 'package:equatable/equatable.dart';

abstract class BalanceEvent extends Equatable {
  const BalanceEvent();

  @override
  List<Object> get props => [];
}

class GetBalance extends BalanceEvent {}
