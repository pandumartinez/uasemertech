class Account {
  // todo : nambah nama lengkap sama url profile picture

  int id;
  String username;
  String first_name;
  String last_name;
  String registration_date;
  String url_image;
  bool is_private;

  Account(
      {this.id = 0,
      this.username = "",
      this.first_name = "",
      this.last_name = "",
      this.registration_date = "",
      this.url_image =
          "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
      this.is_private = false});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
        id: json['user_id'],
        username: json['username'],
        first_name: json['first_name'],
        last_name: json['last_name'] ?? "",
        registration_date: json['registration_date'],
        url_image: json['url_image'] ??
            "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
        is_private: json['is_private'] == 0 ? false : true);
  }
}
