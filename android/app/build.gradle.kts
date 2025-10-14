import java.util.Properties
import java.io.FileInputStream

// โหลด local.properties
val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localProperties.load(FileInputStream(localPropertiesFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // FlutterFire ถ้ามี
}

android {
    namespace = "com.phitthayarat.chatpro"
    compileSdk = localProperties.getProperty("flutter.compileSdkVersion").toInt()

    defaultConfig {
        applicationId = "com.phitthayarat.chatpro"
        minSdk = localProperties.getProperty("flutter.minSdkVersion").toInt()
        targetSdk = localProperties.getProperty("flutter.targetSdkVersion").toInt()
        versionCode = localProperties.getProperty("flutter.versionCode").toInt()
        versionName = localProperties.getProperty("flutter.versionName")
        multiDexEnabled = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

flutter {
    source = "../.."
}
