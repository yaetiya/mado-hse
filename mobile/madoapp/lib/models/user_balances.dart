class UserBalance {
  final String maticTestnet;
  final String maticMainnet;
  final String ethTestnet;
  final String ethMainnet;
  final String totalUsdBalance;
  const UserBalance(this.ethMainnet, this.ethTestnet, this.maticMainnet,
      this.maticTestnet, this.totalUsdBalance);
  static String toFixedBalance(String b) => double.parse(b).toStringAsFixed(4);

  UserBalance.fromJson(Map<String, dynamic> json)
      : maticTestnet = toFixedBalance(json['maticTestnet']),
        maticMainnet = toFixedBalance(json['maticMainnet']),
        ethTestnet = toFixedBalance(json['ethTestnet']),
        ethMainnet = toFixedBalance(json['ethMainnet']),
        totalUsdBalance = json['totalUsdBalance'];
}
