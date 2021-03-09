import 'package:flutter/material.dart';
import 'package:roomiesMobile/presentation/orientation-layout.dart';
import '../../screen-type-layout.dart';
import 'login-view-mobile.dart';

class LoginView extends StatelessWidget
{
  const LoginView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: LoginViewMobile(),
      ),
      
    );

  }

}