

import 'package:auto_route/auto_route.dart';
import '/common_library/services/repository/bill_repository.dart';
import '/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';

import '/common_library/utils/app_localizations.dart';
import '../../router.gr.dart';

@RoutePage()
class AirtimeSelection extends StatelessWidget {
  final primaryColor = ColorConstant.primaryColor;

  final billRepo = BillRepo();

  final Box<dynamic> telcoList = Hive.box('telcoList');

  AirtimeSelection({super.key});

  Future<dynamic> _getTelco(context) async {
    if (telcoList.get('telcoList') == null) {
      var result = await billRepo.getTelco(context: context);

      return result.data;
    }
    return telcoList.get('telcoList');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('airtime_lbl')),
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              height: ScreenUtil().setHeight(1000),
            ),
          ),
          FutureBuilder(
            future: _getTelco(context),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // childAspectRatio: MediaQuery.of(context).size.height / 530,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () => context.router.push(
                        AirtimeBillDetail(data: snapshot.data[index]),
                      ),
                      child: GridTile(
                        child:
                            Image.network(snapshot.data[index].telcoImageUri),
                      ),
                    );
                  },
                );
              }
              return SpinKitFoldingCube(
                color: primaryColor,
              );
            },
          ),
        ],
      ),
    );
  }
}
