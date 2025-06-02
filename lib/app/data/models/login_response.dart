class LoginResponse {
  final String userId;
  final String role;
  final String realId;
  final String redirectEndpoint;

  LoginResponse({
    required this.userId,
    required this.role,
    required this.redirectEndpoint,
    required this.realId,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'role': role,
    'redirectEndpoint': redirectEndpoint,
    'realId': realId,
  };

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['userId'],
      role: json['role'],
      redirectEndpoint: json['redirectEndpoint'],
      realId: json['realId'],
    );
  }
}
