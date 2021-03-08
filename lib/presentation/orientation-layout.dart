import 'package:flutter/material.dart';

class OrientationLayout extends StatelessWidget
{
  final Widget landscape;
  final Widget portrait;

  const OrientationLayout ({Key key, this.landscape, this.portrait}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    Orientation orientation = MediaQuery.of(context).orientation;

    if(orientation == Orientation.landscape){
      // Returns landscape if its not null, otherwise returns portrait.
      return landscape ?? portrait;
    }

    return portrait;
  }

}