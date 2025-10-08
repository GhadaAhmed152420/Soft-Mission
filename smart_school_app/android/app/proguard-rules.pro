# --- Stripe SDK ---
-keep class com.stripe.** { *; }
-keep class proguard.annotation.Keep { *; }
-keepclassmembers class * {
    @proguard.annotation.Keep *;
}

# --- Razorpay SDK ---
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# --- Flutter generated classes ---
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**
