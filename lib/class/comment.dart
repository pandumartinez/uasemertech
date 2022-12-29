class CommentClass {
  int comment_id;
  String comment_content;
  String comment_date;
  int number_likes;

  CommentClass(
      {required this.comment_id,
      required this.comment_content,
      required this.comment_date,
      required this.number_likes});

  factory CommentClass.fromJson(Map<String, dynamic> json) {
    return CommentClass(
        comment_id: json['comment_id'] as int,
        comment_content: json['comment_content'] as String,
        comment_date: json['comment_date'] as String,
        number_likes: json['number_likes'] as int);
  }
}
