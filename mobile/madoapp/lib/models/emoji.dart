class Emoji {
  late String textColor;
  late String name;
  late String symbol;
  late String bgColor;
  Emoji(this.textColor, this.symbol, this.bgColor, this.name);
  Emoji.fromJson(Map<String, dynamic> json) {
    textColor = json['textColor'];
    name = json['name'];
    symbol = json['symbol'];
    bgColor = json['bgColor'];
  }
  toJson() {
    return {
      'textColor': textColor,
      'name': name,
      'symbol': symbol,
      'bgColor': bgColor
    };
  }
}
