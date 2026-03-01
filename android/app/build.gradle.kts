plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.pakrescue_ai"

    // ✅ REQUIRED FOR ANDROID 16 + PLUGINS
    compileSdk = 36

    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.pakrescue_ai"

        minSdk = flutter.minSdkVersion
        targetSdk = 34   // targetSdk can stay 34 (safe & stable)

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Required for Java 17 desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
