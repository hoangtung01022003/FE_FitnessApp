class User {
  final String email;
  final String password;

  User({required this.email, required this.password});

  bool get isLoading => true;
}
