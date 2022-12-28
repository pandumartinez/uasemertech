class Leadboard {
  int id;
  String firstname;
  String lastname;
  int number_likes;

  Leadboard(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.number_likes});

  factory Leadboard.fromJson(Map<String, dynamic> json) {
    return Leadboard(
      id: json['user_id'] as int,
      firstname: json['first_name'] as String,
      lastname: json['last_name'] as String,
      number_likes: json['number_likes'] as int,
    );
  }
}
