import 'dart:convert';
import 'package:appmanga/DatabaseHelper/database_helper.dart';
import 'package:appmanga/Page/Manga_Page/account_page.dart';
import 'package:appmanga/firebase/Firebase.dart';
import 'package:appmanga/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String _message = '';

  Future<void> _login() async {
    final String apiUrl = 'https://magiabaiser.id.vn/api/login';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );
    // Handle response
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['success'] == true) {
        final String token = responseData['data']['token'];
        print(token);
        await DatabaseHelper().insertToken(token);
        await FirebaseApi().initNotifications();
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage()),
        );
      } else {
        setState(() {
          _message = 'Đăng nhập thất bại. ${responseData['message']}';
        });
      }
    } else {
      setState(() {
        _message = 'Đã xảy ra lỗi với mã trạng thái: ${response.statusCode}';
      });
    }
  }

  Future<void> _register() async {
    final String apiUrl = 'https://magiabaiser.id.vn/api/register';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'c_password': _confirmPasswordController.text,
      },
    );

    // Handle response
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('success')) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', responseData['data']['token']);
        setState(() {
          _message = 'Đăng ký thành công!}';
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => MyHomePage()),
          );
        });
      } else {
        setState(() {
          _message = 'Đăng ký thất bại. ${responseData['message']}';
        });
      }
    } else {
      setState(() {
        _message = 'Đã xảy ra lỗi với mã trạng thái: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Authentication'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Login'),
              Tab(text: 'Register'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      child: Text('Login'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      _message,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _register,
                      child: Text('Register'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      _message,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
