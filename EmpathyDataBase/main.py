from flask import Flask, request, jsonify
from threading import Thread
import time


import random

app = Flask(__name__)

# ------------------------------
# 1. ГЕНЕРАЦИЯ ГОТОВЫХ КЛЮЧЕЙ
# ------------------------------

# Ключ → данные об опекаемом
care_keys = {
    "K001": {"ward_name": "Анна", "ward_age": 82, "health": 100, "user": None},
    "K002": {"ward_name": "Павел", "ward_age": 77, "health": 100, "user": None},
    "K003": {"ward_name": "Марина", "ward_age": 91, "health": 100, "user": None},
    "K004": {"ward_name": "Ольга", "ward_age": 74, "health": 100, "user": None},
    "K005": {"ward_name": "Виктор", "ward_age": 85, "health": 100, "user": None}
}

# ------------------------------
# 2. ПАРА ГОТОВЫХ ПОЛЬЗОВАТЕЛЕЙ
# ------------------------------

users = {
    # Пример пользователя, уже привязанного к готовому ключу
    "test_user": {
        "first_name": "Иван",
        "last_name": "Иванов",
        "password": "123456",
        "key": "K001"
    }
}

# Привязываем ключ K001 к пользователю
care_keys["K001"]["user"] = "test_user"

# ------------------------------
# 3. ДИНАМИЧЕСКОЕ ОБНОВЛЕНИЕ ЗДОРОВЬЯ
# ------------------------------

def health_updater():
    while True:
        for key in care_keys:
            care_keys[key]["health"] = random.randint(1, 100)
        time.sleep(5)

Thread(target=health_updater, daemon=True).start()

# ------------------------------
# 4. API: ЛОГИН
# ------------------------------

@app.route("/login", methods=["POST"])
def login():
    data = request.json
    key = data.get("key")
    first = data.get("first_name")
    last = data.get("last_name")
    password = data.get("password")

    # Проверка наличия ключа
    if key not in care_keys:
        return jsonify({"status": "error", "message": "Неверный ключ"})

    # Проверка что ключ привязан к пользователю
    username = care_keys[key]["user"]
    if username is None:
        return jsonify({"status": "error", "message": "Этот ключ ещё не зарегистрирован"})

    user = users.get(username)

    if not user:
        return jsonify({"status": "error", "message": "Пользователь не найден"})

    # Проверка ФИО и пароля
    if user["first_name"] != first or user["last_name"] != last or user["password"] != password:
        return jsonify({"status": "error", "message": "Неверные данные"})

    return jsonify({
        "status": "ok",
        "message": "success",
        "data": {
            "ward_name": care_keys[key]["ward_name"],
            "ward_age": care_keys[key]["ward_age"],
            "health": care_keys[key]["health"]
        }
    })


# ------------------------------
# 5. API: РЕГИСТРАЦИЯ
# ------------------------------

@app.route("/register", methods=["POST"])
def register():
    data = request.json

    key = data.get("key")
    first = data.get("first_name")
    last = data.get("last_name")
    password = data.get("password")

    # Проверка ключа
    if key not in care_keys:
        return jsonify({"status": "error", "message": "Такого ключа нет"})

    # Проверка, что ключ ещё никому не назначен
    if care_keys[key]["user"] is not None:
        return jsonify({"status": "error", "message": "Ключ уже занят"})

    # Создаём username
    username = (first + last + key).lower()

    # Создаём пользователя
    users[username] = {
        "first_name": first,
        "last_name": last,
        "password": password,
        "key": key
    }

    # Привязываем ключ к пользователю
    care_keys[key]["user"] = username

    return jsonify({"status": "ok", "message": "registered"})


# ------------------------------
# 6. API: ПОЛУЧИТЬ ТЕКУЩЕЕ ЗДОРОВЬЕ
# ------------------------------

@app.route("/health/<key>", methods=["GET"])
def health(key):
    if key not in care_keys:
        return jsonify({"status": "error"})
    return jsonify({
        "status": "ok",
        "health": care_keys[key]["health"]
    })


# ------------------------------
# 7. СТАРТ СЕРВЕРА
# ------------------------------

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)
