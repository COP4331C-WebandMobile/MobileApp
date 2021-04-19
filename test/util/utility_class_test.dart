
import 'package:flutter_test/flutter_test.dart';
import 'package:roomiesMobile/utils/utility_functions.dart';

void main()
{
    group('Phone Number Formatting', () {

      test('Reject Numbers Less than 10', (){
        
        final String phoneNumber = '321485';

        final String result = UtilityFunctions.formatNumber(phoneNumber);

        expect(result, phoneNumber);
      });

      test('Reject Numbers Greater than 10', (){
        
        final String phoneNumber = '321485558891';

        final String result = UtilityFunctions.formatNumber(phoneNumber);

        expect(result, phoneNumber);
      });

      test('Reject Non-Number String of 10', () {
        
        final String phoneNumber = 'abcdefghij';

        final String result = UtilityFunctions.formatNumber(phoneNumber);

        expect(result, phoneNumber);
      });

      test('Reject Number/Non-Number mix String of 10', (){
        
        final String phoneNumber = 'ab4d5fghij';

        final String result = UtilityFunctions.formatNumber(phoneNumber);

        expect(result, phoneNumber);
      });

      test('Format Numbers Equal to 10', () {

        final String phoneNumber = '4078589955';

        final String result = UtilityFunctions.formatNumber(phoneNumber);

        final String expectedValue = '407-858-9955';

        expect(result, expectedValue);
      });
    });
}