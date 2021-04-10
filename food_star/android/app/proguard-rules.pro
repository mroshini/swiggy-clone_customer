# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile


#-dontwarn com.android.support.**

#-dontwarn com.squareup.okhttp.**

# Okhttp
#-keepattributes Signature
#-keepattributes Annotation
#-keep class okhttp3.** { *; }
#-keep interface okhttp3.** { *; }
#-dontwarn okhttp3.**

#-dontwarn okio.**

# Retrofit
#-dontwarn retrofit2.**
#-keep class retrofit2.** { *; }
#-keepattributes Signature
#-keepattributes Exceptions

#-keepclasseswithmembers class * {
 #   @retrofit2.http.* <methods>;
#}

#-keep class *{
 #   public private *;
#}


#optimization
#-optimizations   code/simplification/arithmetic,!code/simplification/cast,!field/*,!method/inlining/*
#-optimizationpasses 5
#-allowaccessmodification
#
##retrofit2 rule
#-dontwarn retrofit2.**
#-keep class retrofit2.** { *; }
#-keepattributes Signature,Exceptions,LineNumberTable
#-keepclasseswithmembers class * {
#  @retrofit2.http.* <methods>;
#}
#

##-dontwarn okio.**
#
##library rule
#-dontwarn com.squareup.okhttp.**
#-keep class com.squareup.okhttp3.**
#-keep interface com.squareup.okhttp3.* { *; }
#
#-keep class retrofit.** { *; }
#-keep class package.with.model.classes.** { *; }

#-keepclasseswithmembers class * {
#    @retrofit2.* <methods>;
#}
#
#-keepclassmembernames interface * {
#   @retrofit.http.* <methods>;
#}

#-dontwarn javax.annotation.**

#-dontwarn com.github.mikephil.charting.data.realm.**
#-dontwarn com.squareup.picasso.**
#-dontnote com.squareup.picasso.Utils.**
#-dontnote org.apache.http.**
#-dontnote android.net.http.**
#-keepattributes *Annotation*

#-keep class *{
#   public private *;
#}
#

-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

-keepattributes JavascriptInterface
-keepattributes *Annotation*

-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}

-optimizations !method/inlining/*

-keepclasseswithmembers class * {
  public void onPayment*(...);
}
