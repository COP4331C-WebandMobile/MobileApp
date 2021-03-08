import 'package:flutter/widgets.dart';
import 'package:roomiesMobile/enums/device-screen-type.dart';

DeviceScreenType getDeviceType(MediaQueryData mediaQuery)
{
  double deviceWidth = mediaQuery.size.shortestSide;

  // The width size is too large to be a phone, thus its most likley a Desktop. 
  if(deviceWidth > 950)
  {
    return DeviceScreenType.Desktop;
  }

  if(deviceWidth > 600)
  {
    return DeviceScreenType.Tablet;
  }

  return DeviceScreenType.Mobile;
}