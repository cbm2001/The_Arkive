import 'dart:math';

import 'package:first_app/resources/firestore_methods.dart';
import 'package:first_app/resources/auth_methods.dart';
import 'package:test/test.dart';

void main() {
  test('create user', () async {
    final auth = MockAuthService();
    String res = await auth.createUser('email', 'password');
    expect(res, 'success');
  });

  test('login test with invalid email', () async {
    final auth = MockAuthService();
    String res = await auth.signIn('invalidEmail@test.com', 'password');
    expect(res, 'Invalid Email');
  });

  test('login test with invalid password', () async {
    final auth = MockAuthService();
    String res = await auth.signIn('email', 'invalidPassword');
    expect(res, 'Invalid Password');
  });

  test('Sign out test', () async {
    final auth = MockAuthService();
    String res = await auth.signOut();
    expect(res, 'success');
  });
}

class MockAuthService {
  Future<String> createUser(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    if (email == null) return 'Please enter an email';
    if (password == null) return 'Please enter a password';
    return 'success';
  }

  Future<String> signIn(
    String email,
    String password,
  ) async {
    await Future.delayed(Duration(seconds: 1));
    if (email == 'invalidEmail@test.com') return 'Invalid Email';
    if (password == 'invalidPassword') return 'Invalid Password';
    return 'success';
  }

  Future<String> signOut() async {
    await Future.delayed(Duration(seconds: 1));
    return 'success';
  }
}
