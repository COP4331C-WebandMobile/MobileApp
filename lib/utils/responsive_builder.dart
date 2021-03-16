import 'package:flutter/material.dart';
import 'package:roomiesMobile/utils/sizing_information.dart';
import 'package:roomiesMobile/utils/ui_utils.dart';

class ResponsiveBuilder extends StatelessWidget{
  final Widget Function(BuildContext context, SizingInformation sizingInformation) builder;
  const ResponsiveBuilder({Key key, this.builder}) : super(key: key);

@override
Widget build(BuildContext context)
{ 
  return LayoutBuilder(builder: (context, boxConstraints){
    MediaQueryData mediaQuery = MediaQuery.of(context);
    SizingInformation sizingInformation = SizingInformation(
      deviceScreenType: getDeviceType(mediaQuery),
      screenSize: mediaQuery.size,
      localWidgetSize: Size(boxConstraints.maxWidth, boxConstraints.maxHeight),
    );
    
    return builder(context, sizingInformation);
  });
}

}