import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network_event.dart';
import 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc() : super(const NetworkInitial()) {
    on<SwitchNetwork>((event, emit) async {
      final bool isTestnetNewValue =
          !(networkBloc.state as NetworkLoaded).isTestnet;
      emit(NetworkLoaded(isTestnetNewValue));
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('is-testnet', isTestnetNewValue);
    });
    on<InitNetwork>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final isTestnet = prefs.getBool('is-testnet') ?? true;
      emit(NetworkLoaded(isTestnet));
    });
  }
}

final networkBloc = NetworkBloc();
