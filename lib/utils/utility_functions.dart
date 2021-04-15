class UtilityFunctions {

  static String formatNumber(String phoneNumber) {
    // Can't format an invalid phone number
    if (phoneNumber.length != 10) {
      return phoneNumber;
    }

    if(double.tryParse(phoneNumber) == null)
    {
      return phoneNumber;
    }

    String formattedNumber = '';
    int count = 0;

    for (int i = 0; i < phoneNumber.length; i++) {
      if (i % 3 == 0 && i != 0 && count < 2) {
        formattedNumber += '-';
        count++;
      }

      formattedNumber += phoneNumber[i];
    }

    return formattedNumber;
  }

  static String formatDate(DateTime dateTime)
  {
    return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
  }

  static String formatTime(DateTime dateTime)
  {
    int hour = dateTime.hour;
    final int minutes = dateTime.minute;
    final String prefix = hour >= 12 ? "P.M" : "A.M";
    
    if(hour == 0)
    {
      hour = 12;
    }
    else if(hour > 12)
    {
      hour -= 12;
    }

    return '$hour:$minutes $prefix';
  }

}
