import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Column(
          children: [
            TextButton(
              onPressed: () {
                context.go('/login');
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                context.go('/register');
              },
              child: Text('Register'),
            ),
          ],
        ));
  }
}
