import 'package:formz/formz.dart';

enum NameValidationError { invalid }

class Name extends FormzInput<String, NameValidationError>{
  
  const Name.pure() : super.pure('');
  const Name.dirty([String value = '']) : super.dirty(value);

  static final _nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');

  @override
  NameValidationError validator(String value)
  {
    if(value.length < 2)
      return NameValidationError.invalid;

    return !_nameRegExp.hasMatch(value) ? null : NameValidationError.invalid;
  }
}




