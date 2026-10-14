

 class Utils {
   //Utils._();

   static String formatPrice(double value) {
     if (value == value.truncateToDouble()) {
       return value.toInt().toString();
     }
     return value.toStringAsFixed(2);
   }
 }