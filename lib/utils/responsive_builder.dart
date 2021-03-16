import 'package:flutter/material.dart';
import 'package:roomiesMobile/presentation/sizing-information.dart';
import 'package:roomiesMobile/utils/ui-utils.dart';

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