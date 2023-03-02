abstract class NetworkState {
  const NetworkState();
}

class NetworkInitial extends NetworkState {
  const NetworkInitial();
}

class NetworkLoaded extends NetworkState {
  final bool isTestnet;
  const NetworkLoaded(this.isTestnet);
}
