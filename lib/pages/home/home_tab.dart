

import '/custom_icon/my_custom_icons_icons.dart';
import '/pages/home/home.dart';
import '/pages/invite/invite.dart';
// import '/pages/menu/menu.dart';
import '/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/common_library/utils/app_localizations.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  HomeTabState createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  final primaryColor = ColorConstant.primaryColor;
  final myImage = ImagesConstant();

  final List<Tab> myTabs = <Tab>[
    const Tab(
      icon: Icon(
        MyCustomIcons.homeIcon,
        size: 30,
        color: Color(0xff808080),
      ),
    ),
    const Tab(
      icon: Icon(
        MyCustomIcons.vClubIcon,
        size: 30,
        color: Color(0xff808080),
      ),
    ),
    const Tab(
      icon: Icon(
        MyCustomIcons.inviteIcon,
        size: 30,
        color: Color(0xff808080),
      ),
    ),
    /* Tab(
      icon: new Icon(
        MyCustomIcons.menu_icon,
        size: 30,
        color: Color(0xff808080),
      ),
    ), */
  ];

  TabController? _tabController;
  // int _tabIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: myTabs.length);
    // _tabController.addListener(_getTabSelection);
  }

  /* _getTabSelection() {
    setState(() {
      _tabIndex = _tabController.index;
    });
  } */

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              primaryColor,
            ],
            stops: const [0.45, 0.65],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: Ink(
                  height: ScreenUtil().setHeight(400),
                  color: Colors.white,
                  child: TabBar(
                    tabs: [
                      Tab(
                        icon: const Icon(
                          MyCustomIcons.homeIcon,
                          size: 30,
                          color: Color(0xff808080),
                        ),
                        text:
                            AppLocalizations.of(context)!.translate('home_lbl'),
                      ),
                      Tab(
                        icon: const Icon(
                          MyCustomIcons.vClubIcon,
                          size: 30,
                          color: Color(0xff808080),
                        ),
                        text: AppLocalizations.of(context)!
                            .translate('v_club_lbl'),
                      ),
                      Image.asset(myImage.sos,
                          width: ScreenUtil().setWidth(300)),
                      Tab(
                        icon: const Icon(
                          MyCustomIcons.inviteIcon,
                          size: 30,
                          color: Color(0xff808080),
                        ),
                        text: AppLocalizations.of(context)!
                            .translate('invite_lbl'),
                      ),
                      /* Tab(
                        icon: Icon(
                          MyCustomIcons.menu_icon,
                          size: 30,
                          color: Color(0xff808080),
                        ),
                        text:
                            AppLocalizations.of(context).translate('menu_lbl'),
                      ), */
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: TabBarView(
            controller: _tabController,
            children: const [
              Home(),
              Invite(),
              // Menu(),
            ],
          ),
        ),
      ),
    );
  }
}
