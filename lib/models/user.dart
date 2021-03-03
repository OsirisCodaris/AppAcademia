class User {
  int idusers;
  String fullname;
  String phone;
  String email;
  int module;
  String role;
  String token;
  String refreshToken;

  User(
      {this.idusers,
      this.fullname,
      this.phone,
      this.email,
      this.module,
      this.role,
      this.token,
      this.refreshToken});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idusers: json['idusers'] as int,
      fullname: json['fullname'] as String,
      email: json['email'] as String,
      module: json['module'] as int,
      phone: json['phone'] as String,
      role: json['role'] as String,
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'idusers': idusers,
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
