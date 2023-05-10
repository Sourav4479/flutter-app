import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> todos = [];

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    final response = await http.get(Uri.parse(
        'https://6g1eg4nfd2.execute-api.ap-south-1.amazonaws.com/todos'));
    if (response.statusCode == 200) {
      setState(() {
        todos = json.decode(response.body);
      });
      print('Todos ${this.todos}');
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> signOutCurrentUser(context) async {
    try {
      await Amplify.Auth.signOut();
      Navigator.pushNamed(context, MyRoutes.loginRoute);
      print('User logged out');
    } on AuthException catch (e) {
      print('Error logging out user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Todos"),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = todos[index];
          return ListTile(
            title: Text(todo['title']),
            subtitle: Text('Completed: ${todo['completed']}'),
          );
        },
      ),
    );
  }
}
