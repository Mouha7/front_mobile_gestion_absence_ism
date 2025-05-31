class LoginResponse {
  final String userId;
  final String role;
  final String redirectEndpoint;

  LoginResponse({
    required this.userId,
    required this.role,
    required this.redirectEndpoint,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'role': role,
    'redirectEndpoint': redirectEndpoint,
  };

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['userId'],
      role: json['role'],
      redirectEndpoint: json['redirectEndpoint'],
    );
  }
}
