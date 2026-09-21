class Admin {
  final String username;
  final String password;

  Admin({required this.username, required this.password});

  factory Admin.fromMap(Map<String, dynamic> data) {
    return Admin(
      username: data['username']?.toString() ?? '',
      password: data['password']?.toString() ?? '',
    );
  }
}
