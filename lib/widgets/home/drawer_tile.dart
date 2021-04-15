

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';

class DrawerTile extends StatefulWidget {

  final Widget title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  DrawerTile({
    Key key, 
    this.onTap,
    this.icon,
    this.selected = false,
    @required this.title,
  }) 
  : 
  super(key: key);

  @override
  State<StatefulWidget> createState() => _DrawerTileState();
    
}

class _DrawerTileState extends State<DrawerTile> {
  @override
  Widget build(BuildContext context) {
    
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(32)),

      child: ListTile(
        
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        selected: widget.selected,
        selectedTileColor: CustomColors.gold,
        tileColor: Colors.black,
        leading: Icon(
          widget.icon,
          color: Colors.black,
        ),
        title: widget.title,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(64),
        ),
        onTap: () => widget.onTap(),
        )
    );
  }

}