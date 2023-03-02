import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madoapp/api/balances_api.dart';
import 'package:madoapp/blocs/user/user_bloc.dart';
import 'package:madoapp/blocs/user/user_state.dart';

import 'balance_event.dart';
import 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  BalanceBloc() : super(BalanceInitial()) {
    on<GetBalance>((event, emit) async {
      try {
        String? userAddress = (userBloc.state as UserLoaded).userModel.address;
        if (userAddress == null) return;
        emit(BalanceLoading());
        final balances = await BalancesApi.getBalance(userAddress);
        emit(BalanceLoaded(balances));
      } catch (e) {
        debugPrint('balance');
        debugPrint(e.toString());
        emit(BalanceError(e.toString()));
      }
    });
  }
}

final balanceBloc = BalanceBloc();
