class User {
  final int userId;
  final int id;
  final String title;
  final String body;

  User(
      {required this.userId,
      required this.id,
      required this.title,
      required this.body});

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

/*

class User {
  String name = 'user1';
  String email;
  String password;
  bool mechanical; // 기계식 주차장
  bool largeParking; // 넓은 주차장
  // 요금 및 거리 변수 의논 필요

  User({required this.name, required this.email, required this.password, required this.mechanical, required this.largeParking});
  User.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        email = map['email'],
        password = map['password'],
        mechanical = map['mechanical'],
        largeParking = map['largeParking'];


}*/
