import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'graphql_config.dart'; // Asegúrate de importar la configuración de GraphQL

class LoginForm extends StatelessWidget {
  final TextEditingController UsernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: UsernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Mutation(
              options: MutationOptions(
                document: gql(r'''
                  mutation LoginMutation(
                    $username: String!,
                    $password: String!
                  ) {
                    tokenAuth(username: $username, password: $password) {
                      token
                    }
                  }
                '''),
                onCompleted: (dynamic resultData) async {
                  final token = resultData['tokenAuth'] != null ? resultData['tokenAuth']['token'] : null;
                  if (token != null) {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('auth_token', token);
                    print('Token saved: $token');
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Invalid credentials")),
                    );
                  }
                },
                onError: (error) {
                  print("Error: $error");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("An error occurred")),
                  );
                },
              ),
              builder: (RunMutation runMutation, QueryResult? result) {
                return ElevatedButton(
                  onPressed: () {
                    runMutation({
                      'username': UsernameController.text,
                      'password': passwordController.text,
                    });
                  },
                  child: Text('Login'),
                );
              },
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signup');
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
