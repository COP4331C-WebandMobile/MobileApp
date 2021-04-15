
class UtilityFunctions {
  
static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber == '') {
      return '';
    }

    // Can't format an invalid phone number
    if (phoneNumber.length < 10) {
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


}