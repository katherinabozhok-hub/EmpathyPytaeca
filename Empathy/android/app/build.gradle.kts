plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.empathy" // твой пакет, нужен Flutter 3.10+ для Android Gradle Plugin
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.empathy" // уникальный ID приложения
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
       buildTypes {
    release {
        signingConfig = signingConfigs.getByName("debug")
        isMinifyEnabled = false   // <--- отключаем сжатие кода
        isShrinkResources = false // <--- отключаем удаление ресурсов
    }
}

        debug {
            // debug-параметры можно оставить пустыми
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

flutter {
    source = "../.."
}
