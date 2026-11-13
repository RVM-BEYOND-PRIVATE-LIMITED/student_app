plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.rvm.rvmstudent"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // The development default (student_app #1): the new app has its own
        // id, apart from the old student app's. An application id is
        // permanent once the app is on Play, so it is confirmed under
        // student_app #20 before the first pilot build.
        applicationId = "com.rvm.rvmstudent"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // No release signing is set up here on purpose. The app signing
            // key and the signing route are permanent choices, made under
            // student_app #20 before the first pilot build, and the keystore
            // never enters this repository.
            //
            // The one exception is the CI size report: mobile-ci.yml sets
            // RVM_CI_SIZE_REPORT=true to build a release APK only to measure
            // it. That APK is signed with the throwaway debug key, is never
            // uploaded or installed, and is deleted with the CI runner.
            if (System.getenv("RVM_CI_SIZE_REPORT") == "true") {
                signingConfig = signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
