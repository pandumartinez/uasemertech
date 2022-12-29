class Account {
  // todo : nambah nama lengkap sama url profile picture

  String username;
  String first_name;
  String last_name;
  String registration_date;
  String url_image;

  Account(
      {this.username = "",
      this.first_name = "",
      this.last_name = "",
      this.registration_date = "",
      this.url_image =
          "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png"});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
        username: json['username'],
        first_name: json['first_name'],
        last_name: json['last_name'] ?? "",
        registration_date: json['registration_date'],
        url_image: json['url_image'] ??
            "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png");
  }
}
