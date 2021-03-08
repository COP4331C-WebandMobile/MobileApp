import 'package:flutter/material.dart';
import 'package:roomiesMobile/presentation/screens/home-view-mobile.dart';

import '../orientation-layout.dart';
import '../screen-type-layout.dart';

class HomeView extends StatelessWidget
{
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: HomeMobilePortrait(),
        landscape: HomeMobileLandscape(),
      ),
    );
  }

}