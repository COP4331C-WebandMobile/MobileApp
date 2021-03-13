import 'package:flutter/material.dart';
import 'package:roomiesMobile/presentation/widgets/app-drawer/app-drawer.dart';

class HomeMobilePortrait extends StatelessWidget
{
  final GlobalKey<ScaffoldState> mScaffoldKey = GlobalKey<ScaffoldState>();
  HomeMobilePortrait({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mScaffoldKey,
      drawer: AppDrawer(),
      body: SafeArea(child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: IconButton(
              icon: Icon(Icons.menu, size: 30),
              onPressed: () {
                mScaffoldKey.currentState.openDrawer();
              },
            ),
          ),
        ],  
      ),
      ),
    );
  }


}

class HomeMobileLandscape extends StatelessWidget
{
  const HomeMobileLandscape({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Row(
        children: <Widget>[
          AppDrawer()
        ],
      ),
    );
  }

}