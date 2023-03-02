class Project {
  final String id;
  final String name;
  final String color;
  final String textColor;
  final String url;
  final List<String> tags;
  final String description;
  final bool isTestnet;
  const Project(this.id, this.name, this.color, this.textColor, this.url,
      this.description, this.tags, this.isTestnet);

  Project.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        color = json['color'],
        textColor = json['textColor'],
        isTestnet = json['isTestnet'],
        url = json['url'],
        description = json['description'],
        tags = json['tags'].cast<String>();
}
