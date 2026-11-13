import java.util.Base64

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// The FLAVOR dart-define, as lib/core/env/student_env.dart reads it.
// `flutter build` hands Gradle every --dart-define in the dart-defines
// property, each base64-encoded, comma-separated; the last FLAVOR wins, as
// in Dart. Empty when none was given.
val dartFlavor: String =
    project.findProperty("dart-defines")?.toString().orEmpty()
        .split(",")
        .filter { it.isNotEmpty() }
        .map { String(Base64.getDecoder().decode(it), Charsets.UTF_8) }
        .lastOrNull { it.startsWith("FLAVOR=") }
        ?.removePrefix("FLAVOR=")
        ?.trim()
        ?.lowercase()
        .orEmpty()

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
        // Flutter's default (36, Android 16, on Flutter 3.35.7), never a
        // number of our own, so it moves up with Flutter (student_app #8,
        // item 5). Play raises its minimum every year; tool/check_release.dart
        // fails a release build that targets less than 36.
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // The flavor the Dart code runs as, written into the manifest
        // (com.rvm.rvmstudent.FLAVOR) so tool/check_release.dart can fail a
        // dev build, with its Developer menu and test switches (student_app
        // #8, check 7). It changes nothing at run time. With no FLAVOR, a
        // release build is prod (set below) and any other build is dev, the
        // same rule as StudentEnv.resolve.
        manifestPlaceholders["studentFlavor"] = dartFlavor.ifEmpty { "dev" }
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

            // R8 code shrinking and obfuscation, and resource shrinking
            // (student_app #8, item 5). The Flutter Gradle plugin already
            // turns both on for every release build (Flutter 3.35.7 ignores
            // `--no-shrink`) and adds its own keep rules with
            // proguard-android-optimize.txt; they are stated here so the
            // release build type says what it does, and a test
            // (test/android/android_config_test.dart) keeps them on.
            // R8's mapping file lands in build/app/outputs/mapping/release/
            // and the Dart symbol files come from `--split-debug-info`
            // (tool/build_release.sh): both are kept for crash reports.
            isMinifyEnabled = true
            isShrinkResources = true

            manifestPlaceholders["studentFlavor"] = dartFlavor.ifEmpty { "prod" }
        }
    }
}

flutter {
    source = "../.."
}
