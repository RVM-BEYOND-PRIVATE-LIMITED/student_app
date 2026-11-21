# Razorpay Checkout, from the plugin's own documentation. R8 removes the
# classes the native checkout calls back into without these rules.
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** { *; }
-optimizations !method/inlining/
-keepclasseswithmembers class * {
  public void onPayment*(...);
}
