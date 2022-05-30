import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import './third-party/custom_icon_icons.dart';

import './modules/user_auth/current_user_state.dart';

_launchURL(url) async {
  //const url = 'https://flutter.dev';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class AppScaffoldComponent extends StatefulWidget {
  Widget? body;

  AppScaffoldComponent({this.body});

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffoldComponent> {
  Widget _buildLinkButton(var context, String routePath, String label) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Theme.of(context).primaryColor)),
      ),
      child: ListTile(
        //onPressed: () {
        onTap: () {
          //if (Scaffold.of(context).isEndDrawerOpen) {
          Navigator.of(context).pop();
          //}
          Navigator.pushNamed(context, routePath);
        },
        //child: Text(label),
        title: Text(label, style: TextStyle( color: Theme.of(context).primaryColor )),
      ),
    );
  }

  Widget _buildUserButton(context, currentUserState, { double width = 100, double fontSize = 13 }) {
    if (currentUserState.isLoggedIn) {
      return SizedBox.shrink();
    }
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/login');
      },
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Theme.of(context).accentColor,
        minimumSize: Size.fromWidth(width),
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            //Icon(Icons.person, color: Theme.of(context).primaryColor),
            Image.asset('assets/images/profile.png', width: 30, height: 30),
            Text(
              'Log In',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(context, currentUserState) {
    if (currentUserState.isLoggedIn) {
      return _buildLinkButton(context, '/logout', 'Logout');
    }
    return SizedBox.shrink();
  }

  Widget _buildNavButton(String route, String text, String iconPath, var context, { double width = 100, double fontSize = 13 }) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Theme.of(context).accentColor,
        minimumSize: Size.fromWidth(width),
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            //Icon(icon, color: Theme.of(context).primaryColor),
            Image.asset(iconPath, width: 30, height: 30),
            Text(
              text,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerButton(var context, { double width = 100, double fontSize = 13 }) {
    return Builder(
      builder: (BuildContext context) {
        return TextButton(
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Theme.of(context).accentColor,
            minimumSize: Size.fromWidth(width),
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero)
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                //Icon(Icons.menu, color: Theme.of(context).primaryColor),
                Image.asset('assets/images/profile.png', width: 30, height: 30),
                Text(
                  'More',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildDrawer(var context, var currentUserState) {
    List<Widget> columns = [];
    if (currentUserState.hasRole('admin')) {
    }

    return Drawer(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(''),
              ),
              IconButton(
                icon: Icon(Icons.close),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).pop();
                }
              ),
            ],
          ),
          _buildLogoutButton(context, currentUserState),
          ...columns,
        ],
      ),
    );
  }

  Widget _buildFooter(var context, var currentUserState) {
    List<Widget> rows = [
      Expanded(
        flex: 1,
        child: _buildNavButton('/meditate', 'Meditate', 'assets/images/timer.png', context, width: double.infinity, fontSize: 10),
      ),
      Expanded(
        flex: 1,
        child: _buildNavButton('/meditate-map', 'Map', 'assets/images/map.png', context, width: double.infinity, fontSize: 10),
      ),
      //Expanded(
      //  flex: 1,
      //  child: _buildNavButton('/home', 'Home', Icons.home, context, width: double.infinity, fontSize: 10),
      //)
    ];
    //if (!currentUserState.isLoggedIn) {
    //  rows.add(Expanded(
    //    flex: 1,
    //    child: _buildUserButton(context, currentUserState, width: double.infinity, fontSize: 10),
    //  ));
    //}
    rows.add(
      Expanded(
        flex: 1,
        child: _buildDrawerButton(context, width: double.infinity, fontSize: 10),
      ),
    );

    return SafeArea(
      child: Container(
        height: 55,
        child: Row(
          children: <Widget>[
            ...rows,
          ]
        ),
        //decoration: BoxDecoration(
        //  boxShadow: [
        //    BoxShadow(
        //      color: Colors.grey.shade300,
        //      spreadRadius: 2,
        //      blurRadius: 4,
        //      offset: Offset(0, 0),
        //    )
        //  ]
        //),
      )
    );
  }

  Widget _buildBody(var context, var currentUserState, { bool footer = false }) {
    if (footer) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 1200,
                  child: widget.body,
                  //color: Colors.white,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/sun.jpg'),
                      fit: BoxFit.fill,
                    )
                  ),
                )
              )
            )
          ),
          _buildFooter(context, currentUserState),
        ]
      );
    }
    return Container(
      color: Theme.of(context).primaryColor,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 1200,
          child: widget.body,
          //color: Colors.white,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/sun.jpg'),
              fit: BoxFit.fill,
            )
          ),
        )
      )
    );
  }

  Widget _buildSmall(var context, var currentUserState) {
    return Scaffold(
      endDrawer: _buildDrawer(context, currentUserState),
      body: _buildBody(context, currentUserState, footer: true),
    );
  }

  Widget _buildMedium(var context, var currentUserState) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Image.asset('assets/images/logo.png', width: 100, height: 50),
        actions: <Widget>[
          //_buildNavButton('/home', 'Home', Icons.home, context),
          _buildNavButton('/meditate', 'Meditate', 'assets/images/timer.png', context),
          _buildNavButton('/meditate-map', 'Map', 'assets/images/map.png', context),
          //_buildUserButton(context, currentUserState),
          _buildDrawerButton(context),
        ],
      ),
      endDrawer: _buildDrawer(context, currentUserState),
      body: _buildBody(context, currentUserState),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentUserState = context.watch<CurrentUserState?>();
    return LayoutBuilder(
      builder: (context, constraints) {
        //if (constraints.maxWidth > 600) {
        //  return _buildMedium(context, currentUserState);
        //} else {
        //  return _buildSmall(context, currentUserState);
        //}
        return _buildSmall(context, currentUserState);
      }
    );
  }
}
