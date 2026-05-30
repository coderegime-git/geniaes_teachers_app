# ───────────────────────────────────────────────
# Pusher Beams & Pusher Channels
# ───────────────────────────────────────────────
-keep class com.pusher.** { *; }
-keep interface com.pusher.** { *; }
-keepclassmembers class com.pusher.** { *; }

# ───────────────────────────────────────────────
# Firebase Messaging (FCM)
# ───────────────────────────────────────────────
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class io.flutter.plugins.firebase.** { *; }
-keepclassmembers class com.google.firebase.messaging.FirebaseMessagingService { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# ───────────────────────────────────────────────
# Gson (used internally by Pusher Beams)
# ───────────────────────────────────────────────
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-keep class * extends com.google.gson.TypeAdapter { *; }
-keep class * implements com.google.gson.TypeAdapterFactory { *; }
-keep class * implements com.google.gson.JsonSerializer { *; }
-keep class * implements com.google.gson.JsonDeserializer { *; }
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# ───────────────────────────────────────────────
# OkHttp & Okio (used by Pusher Beams for HTTP)
# ───────────────────────────────────────────────
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-keep class okio.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**

# ───────────────────────────────────────────────
# Flutter & Dart (prevent stripping of native bridges)
# ───────────────────────────────────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }

# ───────────────────────────────────────────────
# General - keep all annotated entry points
# ───────────────────────────────────────────────
-keepattributes EnclosingMethod
-keepattributes InnerClasses
-keep @androidx.annotation.Keep class * { *; }
-keepclasseswithmembers class * {
    @androidx.annotation.Keep <methods>;
}

# ───────────────────────────────────────────────
# Play Core (Deferred Components & App Bundles)
# ───────────────────────────────────────────────
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# ───────────────────────────────────────────────
# Added rules for Pusher & Flutter Local Notifications (based on student app fix)
# ───────────────────────────────────────────────
-dontwarn com.pusher.**

-keep class com.dexterous.** { *; }
-dontwarn com.dexterous.**
