
import 'package:auto_route/auto_route.dart';
import 'package:edriving_spim_app/common_library/utils/app_localizations.dart';
import '/common_library/services/repository/epandu_repository.dart';
import '/common_library/services/repository/inbox_repository.dart';
import '/common_library/utils/local_storage.dart';
import '/custom_icon/my_custom_icons_icons.dart';
import '/router.gr.dart';
import '/services/provider/notification_count.dart';
import '/utils/constants.dart';
import '/common_library/utils/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTopMenu extends StatefulWidget {
  final dynamic iconText;
  final dynamic getDiProfile;
  final dynamic getActiveFeed;

  const HomeTopMenu({super.key, 
    this.iconText,
    this.getDiProfile,
    this.getActiveFeed,
  });

  @override
  HomeTopMenuState createState() => HomeTopMenuState();
}

class HomeTopMenuState extends State<HomeTopMenu> {
  bool showBadge = false;
  final epanduRepo = EpanduRepo();
  final myImage = ImagesConstant();
  final customDialog = CustomDialog();
  String barcode = "";
  final inboxRepo = InboxRepo();
  final localStorage = LocalStorage();
  final dynamic positionStream;

  HomeTopMenuState({this.positionStream});

  getUnreadNotificationCount() async {
    var result = await inboxRepo.getUnreadNotificationCount();

    if (mounted) {
      if (result.isSuccess) {
        if (int.tryParse(result.data[0].msgCount)! > 0) {
          Provider.of<NotificationCount>(context, listen: false).setShowBadge(
            showBadge: true,
          );

          Provider.of<NotificationCount>(context, listen: false)
              .updateNotificationBadge(
            notificationBadge: int.tryParse(result.data[0].msgCount),
          );
        } else {
          Provider.of<NotificationCount>(context, listen: false).setShowBadge(
            showBadge: false,
          );
        }
      } else {
        Provider.of<NotificationCount>(context, listen: false).setShowBadge(
          showBadge: false,
        );
      }
    }
  }

  /* registerUserToDi(barcode) async {
    ScanResponse scanResponse = ScanResponse.fromJson(jsonDecode(barcode));

    var result = await authRepo.registerUserToDI(
      context: context,
      // name: scanResponse.name,
      // phoneCountryCode: scanResponse.phoneCountryCode,
      // phone: scanResponse.phone,
      // userId: scanResponse.userId,
      scanCode: barcode,
    );

    if (result.isSuccess) {
      Navigator.push(context, REGISTER_USER_TO_DI,
          arguments: ScanResultArgument(
            barcode: scanResponse,
            status: 'success',
          ));
    } else {
      Navigator.push(context, REGISTER_USER_TO_DI,
          arguments: ScanResultArgument(
            barcode: scanResponse,
            status: 'fail',
          ));
    }
  } */

  @override
  Widget build(BuildContext context) {
    //bool showBadge = context.watch<NotificationCount>().showBadge;
    //int? badgeNo = context.watch<NotificationCount>().notificationBadge;
    Size size = MediaQuery.of(context).size;

    return SizedBox(
        height: size.height * 0.35,
        child: Stack(
          children: <Widget>[
            Container(
                height: size.height * 0.35 - 50,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 243, 205, 56),
                      Colors.white,],
                      stops: [0.45, 0.85],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          ),
                    ),
                child: Stack(children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 32),
                    child: Column(
                      children: <Widget>[
                        Row(children: <Widget>[
                          Image.asset(
                            'assets/images/ePandu-logo.png',
                            height: 90,
                            width: 180,
                            alignment: Alignment.center,
                          ),
                          Image.asset(
                            'assets/images/Axia.png',
                            height: 90,
                            width: 160,
                            alignment: Alignment.center,
                          ),
                        ]),
                      ],
                    ),
                  ),
                ])),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 140, 20, 0),
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              height: 170,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 10),
                        blurRadius: 50,
                        color: kPrimaryColor.withOpacity(0.2))
                  ]),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment:CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: () => context.router.push(const Pay()),
                        borderRadius: BorderRadius.circular(10.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18))),
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                Icons.qr_code,
                                color: Color.fromARGB(255, 32, 56, 90),
                                size: 30,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                    .translate('pay_lbl'),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                          onTap: () => context.router.push(const Invite()),
                          borderRadius: BorderRadius.circular(10.0),
                          child: Column(children: <Widget>[
                            Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18))),
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                MyCustomIcons.inviteIcon,
                                color: Color.fromARGB(255, 32, 56, 90),
                                size: 30,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                    .translate('invite_lbl'),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                          ])),
                      InkWell(
                          onTap: () => context.router
                              .push(const Inbox())
                              .then((value) => getUnreadNotificationCount()),
                          borderRadius: BorderRadius.circular(10.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18))),
                                padding: const EdgeInsets.all(12),
                                child: const Icon(
                                  MyCustomIcons.inboxIcon,
                                  color: Color.fromARGB(255, 32, 56, 90),
                                  size: 30,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .translate('inbox_lbl'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                            ],
                          )),
                          InkWell(
                          onTap: () => context.router.push(
                                Scan(
                                  getActiveFeed: widget.getActiveFeed,
                                  getDiProfile: widget.getDiProfile,
                                ),
                              ),
                          borderRadius: BorderRadius.circular(10.0),
                          child: Column(children: <Widget>[
                            Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18))),
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                MyCustomIcons.scanIcon,
                                color: Color.fromARGB(255, 32, 56, 90),
                                size: 30,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                    .translate('scan_lbl'),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                          ])),
                    ],
                  ),
                  Row(
                crossAxisAlignment:CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //new icon
                  InkWell(
                    onTap: () => context.router.push(const Vehicle()),
                    borderRadius: BorderRadius.circular(10.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18))),
                            padding: const EdgeInsets.all(12),
                            child: const Icon(
                              Icons.directions_car,
                              color: Color.fromARGB(255, 32, 56, 90),
                              size: 30,
                            ),
                          ),
                        Text(
                            AppLocalizations.of(context)!
                                .translate('vehicle_lbl'),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Colors.black),),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => context.router.push(const Class()),
                    borderRadius: BorderRadius.circular(10.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18))),
                            padding: const EdgeInsets.all(12),
                            child: const Icon(
                              Icons.alarm,
                              color: Color.fromARGB(255, 32, 56, 90),
                              size: 30,
                            ),
                          ),
                        Text(
                            AppLocalizations.of(context)!
                                .translate('class_lbl'),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Colors.black),),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: ()=> context.router.push(const TrainerSchedule()),
                    borderRadius: BorderRadius.circular(10.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18))),
                            padding: const EdgeInsets.all(12),
                            child: const Icon(
                              Icons.calendar_month,
                              color: Color.fromARGB(255, 32, 56, 90),
                              size: 30,
                            ),
                          ),
                        Text(
                            AppLocalizations.of(context)!
                                .translate('scd_lbl'),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Colors.black),),
                      ],
                    ),
                  ),
                ],
              ),
                ],
              ),
              
            ),
          ],
        ));

    /*return SizedBox(
      height: ScreenUtil().setHeight(350),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Table(
              // border: TableBorder.all(),
              children: [
                TableRow(
                  children: [
                    InkWell(
                      onTap: () => context.router.push(
                        Scan(
                          getActiveFeed: widget.getActiveFeed,
                          getDiProfile: widget.getDiProfile,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            const Icon(
                              MyCustomIcons.scan_icon,
                              size: 26,
                              color: Color(0xff808080),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(20)),
                            Text(
                                AppLocalizations.of(context)!
                                    .translate('scan_lbl'),
                                style: widget.iconText),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => context.router.push(const Pay()),
                      borderRadius: BorderRadius.circular(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            const Icon(
                              MyCustomIcons.scan_helper,
                              size: 26,
                              color: Color(0xff808080),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(20)),
                            Text(
                                AppLocalizations.of(context)!
                                    .translate('pay_lbl'),
                                style: widget.iconText),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => context.router.push(const Invite()),
                      borderRadius: BorderRadius.circular(10.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Column(
                          children: <Widget>[
                            const Icon(
                              MyCustomIcons.invite_icon,
                              size: 26,
                              color: Color(0xff808080),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(20)),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('invite_lbl'),
                              style: widget.iconText,
                            ),
                          ],
                        ),
                      ),
                    ),
                    /* Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Image.memory(kTransparentImage,
                              width: ScreenUtil().setWidth(150)),
                        ],
                      ),
                    ), */
                    InkWell(
                      onTap: () => context.router.push(const IdentityBarcode()),
                      borderRadius: BorderRadius.circular(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            const Icon(
                              MyCustomIcons.id_icon,
                              size: 26,
                              color: Color(0xff808080),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(20)),
                            Text(
                                AppLocalizations.of(context)!
                                    .translate('id_lbl'),
                                style: widget.iconText),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => context.router
                          .push(const Inbox())
                          .then((value) => getUnreadNotificationCount()),
                      borderRadius: BorderRadius.circular(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Badge(
                              showBadge: showBadge,
                              badgeContent: Text(
                                '$badgeNo',
                                style: const TextStyle(color: Colors.white),
                              ),
                              child: const Icon(
                                MyCustomIcons.inbox_icon,
                                size: 26,
                                color: Color(0xff808080),
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(20)),
                            Text(
                                AppLocalizations.of(context)!
                                    .translate('inbox_lbl'),
                                style: widget.iconText),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          /* Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () =>
                  context.router.push(Routes.epanduCategory),
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                padding: EdgeInsets.only(
                  top: 85.h,
                ),
                // margin: EdgeInsets.only(bottom: 80.h),
                child: Column(
                  children: <Widget>[
                    FadeInImage(
                      alignment: Alignment.center,
                      placeholder: MemoryImage(kTransparentImage),
                      height: 90.h,
                      image: AssetImage(
                        myImage.logo2,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(AppLocalizations.of(context).translate('log_in'),
                        style: widget.iconText),
                  ],
                ),
              ),
            ),
          ), */
        ],
      ),
    );*/
  }
}
