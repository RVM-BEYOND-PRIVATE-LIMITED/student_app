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

// #73 — the upload key comes from CI only. No keystore, password or
// key-properties file is ever in git. The size-report path stays on the debug
// key so a measured APK can never be mistaken for a Play build.
val uploadKeystoreB64: String? = System.getenv("ANDROID_UPLOAD_KEYSTORE_B64")
val uploadKeystorePassword: String? = System.getenv("ANDROID_UPLOAD_KEYSTORE_PASSWORD")
val uploadKeyAlias: String? = System.getenv("ANDROID_UPLOAD_KEY_ALIAS")
val uploadKeyPassword: String? = System.getenv("ANDROID_UPLOAD_KEY_PASSWORD")
val hasUploadKey: Boolean = listOf(
    uploadKeystoreB64, uploadKeystorePassword, uploadKeyAlias, uploadKeyPassword,
).all { !it.isNullOrBlank() }

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

    signingConfigs {
        if (hasUploadKey) {
            create("release") {
                val keystore = layout.buildDirectory.file("upload-keystore.jks").get().asFile
                keystore.parentFile.mkdirs()
                keystore.writeBytes(Base64.getDecoder().decode(uploadKeystoreB64))
                storeFile = keystore
                storePassword = uploadKeystorePassword
                keyAlias = uploadKeyAlias
                keyPassword = uploadKeyPassword
            }
        }
    }

    buildTypes {
        release {
            // #73 — a release build is signed with the upload key from CI
            // only (the signingConfigs block above), never with a key in git.
            // The CI size report is the only debug-signed path: mobile-ci.yml
            // sets RVM_CI_SIZE_REPORT=true to build a release APK only to
            // measure it. That APK is never uploaded or installed.
            if (System.getenv("RVM_CI_SIZE_REPORT") == "true") {
                signingConfig = signingConfigs.getByName("debug")
            } else if (hasUploadKey) {
                signingConfig = signingConfigs.getByName("release")
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
            // Razorpay Checkout's callback classes are reached from its
            // native activity, so R8 must keep them (proguard-rules.pro).
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )

            manifestPlaceholders["studentFlavor"] = dartFlavor.ifEmpty { "prod" }
        }
    }
}

flutter {
    source = "../.."
}

// Firebase Crashlytics activates only when the Firebase config is
// present (android/app/google-services.json, Android app package
// com.rvm.rvmstudent).
if (file("google-services.json").exists()) {
    apply(plugin = "com.google.gms.google-services")
    apply(plugin = "com.google.firebase.crashlytics")
}
