class SocialNetwork {
  final String url;
  final String title;
  final String iconPath;
  const SocialNetwork(this.iconPath, this.title, this.url);
  SocialNetwork.fromJson(Map<String, dynamic> json)
      : iconPath = json['iconPath'],
        title = json['title'],
        url = json['url'];
}
