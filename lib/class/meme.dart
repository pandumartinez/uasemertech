class Meme {
  final int id;
  final String url_image;
  final String top_text;
  final String bottom_text;
  final int number_likes;

  Meme(
      {required this.id,
      required this.url_image,
      required this.top_text,
      required this.bottom_text,
      required this.number_likes});

  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(
      id: json['meme_id'] as int,
      url_image: json['url_image_meme'] as String,
      top_text: json['top_text'] as String,
      bottom_text: json['bottom_text'] as String,
      number_likes: json['number_likes'] as int
    );
  }
}
