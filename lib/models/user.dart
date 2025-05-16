class User {
  final String username;
  final String email;
  final String password;

  User(this.username, {required this.email, required this.password});

  bool get isLoading => true;
}
