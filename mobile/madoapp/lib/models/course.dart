class Course {
  final String uid;
  final String name;
  final String preview;
  final String shortDescription;
  final String description;
  final List<Part> parts;
  final bool isNotReady;
  final bool isTestnet;

  Course(this.uid, this.name, this.description, this.preview,
      this.shortDescription, this.isNotReady, this.parts, this.isTestnet);
  Course.fromJson(Map<String, dynamic> json)
      : uid = json['_id'],
        preview = json['preview'],
        shortDescription = json['shortDescription'],
        description = json['description'],
        isTestnet = json['isTestnet'] ?? true,
        isNotReady = json['isNotReady'] ?? false,
        parts =
            (json['parts'] as List).map((part) => Part.fromJson(part)).toList(),
        name = json['name'];
  factory Course.fromJsonWithoutParts(Map<String, dynamic> json) {
    json["parts"] = [];
    return Course.fromJson(json);
  }
  Map<String, dynamic> toJson() => {
        '_id': uid,
        'preview': preview,
        'name': name,
        'shortDescription': shortDescription,
        'description': description,
        'isNotReady': isNotReady,
        'isTestnet': isTestnet,
        'parts': parts.map((e) => e.toJson()).toList(),
      };
  // static Course generateMocked() {
  //   var rng = Random();
  //   return Course(
  //       '62ed3a9f899af4914dd7c90e',
  //       'Mocked name',
  //       htmlContentExample,
  //       // 'https://i.pinimg.com/564x/9f/8a/99/9f8a9930bfb1991db28c83bb63dc15ec.jpg',
  //       'https://source.unsplash.com/random/${400 + rng.nextInt(200)}x${400 + rng.nextInt(200)}?v=' +
  //           rng.nextInt(500).toString(),
  //       'Get to know WETH, USDT and other assets',
  //       true,
  //       [
  //         Part(null, htmlContentExample),
  //         Part('https://app.uniswap.org/', "Something"),
  //         Part('https://pancakeswap.finance/', htmlContentExample),
  //       ]);
  // }
}

class Part {
  final String? interactiveUrl;
  final String content;
  Part.fromJson(Map<String, dynamic> json)
      : interactiveUrl = json['interactiveUrl'],
        content = json['content'];

  Map<String, dynamic> toJson() =>
      {'interactiveUrl': interactiveUrl, 'content': content};
  Part(
    this.interactiveUrl,
    this.content,
  );
}
