class Meme {
  int id;
  String url_image;
  String top_text;
  String bottom_text;
  int number_likes;
  final List? users;

  Meme(
      {required this.id,
      required this.url_image,
      required this.top_text,
      required this.bottom_text,
      required this.number_likes,
      required this.users});

  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(
        id: json['meme_id'] as int,
        url_image: json['url_image_meme'] as String,
        top_text: json['top_text'] as String,
        bottom_text: json['bottom_text'] as String,
        number_likes: json['number_likes'] as int,
        users: json['users']);
  }
}
