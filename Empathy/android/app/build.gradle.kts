plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.empathy"
    compileSdk = 34 // changed from 36 (too new/beta) to 34 (stable) or 35

    defaultConfig {
        applicationId = "com.example.empathy"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        getByName("release") {
            // Note: Ensure you have a signingConfig defined if you use this line,
            // otherwise comment it out for now to avoid build errors.
            signingConfig = signingConfigs.getByName("debug")
            
            isMinifyEnabled = false
            isShrinkResources = false
        }

        getByName("debug") {
            // debug options
        }
    }

    compileOptions {
        // --- FIX START: Enable Desugaring ---
        isCoreLibraryDesugaringEnabled = true
        // --- FIX END ---

        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

// --- FIX START: Add Dependency for Desugaring ---
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
// --- FIX END ---

flutter {
    source = "../.."
}