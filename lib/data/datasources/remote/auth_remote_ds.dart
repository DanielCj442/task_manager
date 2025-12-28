//TODO: Dio + Node.JS
class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'test@test.com' && password == '123456') {
      return {
        'id': '1',
        'email': email,
      };
    } else {
      throw Exception('Invalid credentials');
    }
  }
}
