import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class RegistrationScreen extends StatefulWidget {
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

//сначала тут все то же самое что и в логинскрине, контроллеры для полей ввода, строка ошибки и статичный ключ доступа

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _accessKeyController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? errorMessage;
  String correctpas = "ebalbabulku69"; // статичный ключ (оставим отсылочку)

 void _tryRegister() async { //контроооооллеры
  final name = _nameController.text.trim();
  final surname = _surnameController.text.trim();
  final accessKey = _accessKeyController.text.trim();
  final password = _passwordController.text.trim();
  final confirmPassword = _confirmPasswordController.text.trim();

  setState(() => errorMessage = null);

  if (name.isEmpty || surname.isEmpty || accessKey.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
    setState(() => errorMessage = "Пожалуйста, заполните все поля");
    return;
  } //проверка на пустые поля

  if (password != confirmPassword) {
    setState(() => errorMessage = "Пароли не совпадают");
    return;
  }

  try { //мы тут отправляем запрос на данные регистрации на сервер
    final response = await http.post(
      Uri.parse("http://127.0.0.1:5000/register"), // эндпоинт регистрации на сервере
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "surname": surname,
        "access_key": accessKey,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["success"] == true) { //тут проверка ключа, она на серваке висит
        Navigator.pushReplacementNamed(context, "/login");
      } else {
        setState(() => errorMessage = data["message"]);
      }
    } else {
      setState(() => errorMessage = "Ошибка сервера, попробуйте позже");
    }
  } catch (e) {
    setState(() => errorMessage = "Ошибка подключения к серверу");
  }
}


  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _accessKeyController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Регистрация")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Name", 
                hintText: "Введите имя",
                filled: true,                
                fillColor: Colors.white),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(
                labelText: "Surname", 
                hintText: "Введите фамилию",
                filled: true,                
                fillColor: Colors.white),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _accessKeyController,
              decoration: InputDecoration(
                labelText: "Access key", 
                hintText: "Введите код доступа",
                filled: true,                
                fillColor: Colors.white),
              obscureText: true,
            ),
            SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password", 
                hintText: "Введите пароль",
                filled: true,                
                fillColor: Colors.white),
              obscureText: true,
            ),
            SizedBox(height: 12),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: "Confirm Password", 
                hintText: "Введите пароль еще раз",
                filled: true,                
                fillColor: Colors.white),
              obscureText: true,
            ),
            SizedBox(height: 16),
            if (errorMessage != null)
              Text(errorMessage!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 24),
            ElevatedButton(onPressed: _tryRegister, child: Text("Зарегистрироваться")),
          ],
        ),
      ),
    );
  }
}


//Я заебалась это писать когда уже это закончится я хочу поспать Тимур верни паспорт