import 'package:madoapp/models/user_balances.dart';

abstract class BalanceState {
  const BalanceState();
}

class BalanceInitial extends BalanceState {}

class BalanceLoading extends BalanceState {}

class BalanceLoaded extends BalanceState {
  final UserBalance balanceModel;
  const BalanceLoaded(this.balanceModel);
}

class BalanceError extends BalanceState {
  final String? message;
  const BalanceError(this.message);
}
