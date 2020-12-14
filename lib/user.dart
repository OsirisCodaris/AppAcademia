class User {
  final int idusers;
  final String fullname;
  final String phone;
  final String email;
  final int module;
  final String role;
  final String token;
  final String refreshToken;

  User(
      {this.idusers,
      this.fullname,
      this.phone,
      this.email,
      this.module,
      this.role,
      this.token,
      this.refreshToken});

  Map<String, dynamic> toMap() {
    return {
      'id': idusers,
      'fullname': fullname,
      'phone': phone,
      'email': email,
      'module': module,
      'role': role,
      'token': token,
      'refreshToken': refreshToken,
    };
  }

  @override
  String toString() {
    return 'User{idusers: $idusers, fullname: $fullname, phone: $phone, email: $email,module: $module,role: $role,token: $token,refreshToken: $refreshToken}';
  }
}
