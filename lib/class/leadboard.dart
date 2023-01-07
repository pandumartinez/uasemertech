class Leadboard {
  int id;
  String firstname;
  String lastname;
  String url_image;
  int number_likes;
  bool isPrivate;

  Leadboard(
      {required this.id,
      required this.firstname,
      this.lastname = "",
      this.url_image =
          "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
      required this.number_likes,
      this.isPrivate = false});

  factory Leadboard.fromJson(Map<String, dynamic> json) {
    return Leadboard(
      id: json['user_id'] as int,
      firstname: json['first_name'] ?? "",
      lastname: json['last_name'] ?? "",
      url_image: json['url_image'] ??
          "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
      number_likes: json['number_likes'] as int,
      isPrivate: json['is_private'] == 0 ? false : true,
    );
  }
}
