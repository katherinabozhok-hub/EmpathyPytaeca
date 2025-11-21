import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';



class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState(); //создаем состояние для нашего логинскрина, т.к. у нас уже нет статичного экрана, а будет несколько состояний
}

class _LoginScreenState extends State<LoginScreen> { //сам класс состояния, дочерний по отношению к ЛогинСкрин
  final TextEditingController _loginController = TextEditingController(); //контроллеры для полей ввода, неизменимы чтобы не поставить условно контроллер пароля в контроллер логина
  final TextEditingController _passwordController = TextEditingController(); //они будут хранить введенные юзером данные и позволять с ними работать

  String? errorMessage; // строка ошибки (null = нет ошибки)

  

void _tryLogin() async {
  final login = _loginController.text.trim();
  final password = _passwordController.text.trim();

  if (login.isEmpty || password.isEmpty) {
    setState(() {
      errorMessage = "Введите логин и пароль";
    });
    return;
  }

  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/login'), // адрес вашего Flask-сервера
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"login": login, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
     if (data['success'] == true) {
  setState(() => errorMessage = null);

  // Сохраняем факт, что пользователь вошел
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', true);
  await prefs.setString('userLogin', login); // если нужно хранить логин

  Navigator.pushReplacementNamed(
  context,
  '/home',
  arguments: {'token': login}, // передаём токен, здесь можно login или любой уникальный идентификатор
);
}
else {
        setState(() {
          errorMessage = "Логин или пароль введены неверно, повторите попытку";
        });
      }
    } else {
      setState(() {
        errorMessage = "Ошибка сервера: попробуйте позже";
      });
    }
  } catch (e) {
    setState(() {
      errorMessage = "Не удалось подключиться к серверу";
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 171, 194, 242),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Поле логина
              TextField(
                controller: _loginController,
                decoration: InputDecoration(
                  filled: true,                
                  fillColor: Colors.white,
                  labelText: "Логин (Имя, Фамилия пользователя)",          
                  hintText: "Введите имя и фамилию",   
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Поле пароля
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,                
                  fillColor: Colors.white,
                  labelText: "Пароль",
                  hintText: "Введите пароль",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),


              if (errorMessage != null)
                Text(
                  errorMessage!, // восклицательный знак говорит что тут сто проц не нулл
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center, // текст по центру
                ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _tryLogin,
                child: Text("Войти"),
              ),
            ],
          ),
        ),
      ),
    );
  }
     @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}