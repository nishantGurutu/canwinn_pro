# Keep Jackson classes and prevent missing bean classes
-keep class com.fasterxml.jackson.databind.** { *; }
-keep class com.fasterxml.jackson.annotation.** { *; }
-keep class com.fasterxml.jackson.core.** { *; }
-keep class com.fasterxml.jackson.module.** { *; }
-keepclassmembers class * {
    @com.fasterxml.jackson.annotation.* <methods>;
    @com.fasterxml.jackson.annotation.* <fields>;
}
-keepclassmembers class * {
    @com.fasterxml.jackson.annotation.JsonCreator <init>(...);
}
-keepclassmembers class * {
    @com.fasterxml.jackson.annotation.JsonProperty *;
}

# Keep java.beans classes
-keep class java.beans.** { *; }

# Keep Conscrypt and prevent missing SSLParametersImpl
-keep class org.conscrypt.** { *; }
-dontwarn org.conscrypt.**

# Also keep the internal class that is being removed
-keep class com.android.org.conscrypt.** { *; }

# General Flutter and Firebase keep rules
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.google.firebase.** { *; }
-dontwarn io.flutter.embedding.**
-ignorewarnings
