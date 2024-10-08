import 'package:auto_route/auto_route.dart';
import '/common_library/utils/app_localizations.dart';
import '/common_library/services/repository/fpx_repository.dart';
import '/utils/constants.dart';
import '/common_library/utils/custom_dialog.dart';
import '/common_library/utils/local_storage.dart';
import '/common_library/utils/loading_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../router.gr.dart';

@RoutePage()
class OrderList extends StatefulWidget {
  final String? icNo;
  final String? packageCode;
  final String? diCode;

  const OrderList({super.key, 
    this.icNo,
    this.packageCode,
    this.diCode,
  });

  @override
  OrderListState createState() => OrderListState();
}

class OrderListState extends State<OrderList> {
  final fpxRepo = FpxRepo();
  final localStorage = LocalStorage();
  Future? getOrderList;
  final primaryColor = ColorConstant.primaryColor;
  final customDialog = CustomDialog();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    getOrderList = getOrderListByIcNo();
  }

  getOrderListByIcNo() async {
    var result = await fpxRepo.getOrderListByIcNo(
      context: context,
      icNo: widget.icNo,
      startIndex: '-1',
      noOfRecords: '-1',
      diCode: widget.diCode,
    );

    if (result.isSuccess) {
      return result.data;
    }
    return result.message;
  }

  getOnlinePaymentByOrderNo({docDoc, docRef}) async {
    setState(() {
      isLoading = true;
    });

    var result = await fpxRepo.getOnlinePaymentByOrderNo(
      diCode: widget.diCode,
      icNo: widget.icNo,
      docDoc: docDoc,
      docRef: docRef,
    );

    if (result.isSuccess) {
      if (!context.mounted) return;
      context.router.push(
        Webview(url: result.data[0].receiptUrl),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('select_order')),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: getOrderList,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Container(
                    padding: const EdgeInsets.all(15.0),
                    margin: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 8.0),
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: SpinKitFoldingCube(
                        color: primaryColor,
                      ),
                    ),
                  );
                case ConnectionState.done:
                  if (snapshot.data is String) {
                    return Center(
                      child: Text(snapshot.data),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.data[index].packageCode != 'PURCHASE') {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 40.w, vertical: 20.h),
                          child: InkWell(
                            onTap: () {
                              if (snapshot.data[index].trnStatus
                                      .toUpperCase() !=
                                  'PAID') {
                                context.router.push(
                                  FpxPaymentOption(
                                    icNo: widget.icNo,
                                    docDoc: snapshot.data[index].docDoc,
                                    docRef: snapshot.data[index].docRef,
                                    merchant: snapshot.data[index].merchantNo,
                                    packageCode: widget.packageCode,
                                    packageDesc:
                                        snapshot.data[index].packageDesc,
                                    diCode: widget.diCode,
                                    totalAmount: double.tryParse(
                                            snapshot.data[index].tlOrdAmt)!
                                        .toStringAsFixed(2),
                                  ),
                                );
                              } else {
                                /* customDialog.show(
                                context: context,
                                content: AppLocalizations.of(context)
                                    .translate('order_paid'),
                                type: DialogType.INFO); */
                                getOnlinePaymentByOrderNo(
                                    docDoc: snapshot.data[index].docDoc,
                                    docRef: snapshot.data[index].docRef);
                              }
                            },
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 20.h),
                                child: Table(
                                  columnWidths: const {
                                    1: FractionColumnWidth(.35)
                                  },
                                  children: [
                                    TableRow(
                                      children: [
                                        Text(
                                            '${AppLocalizations.of(context)!.translate('order')}: ${snapshot.data[index].docDoc}${snapshot.data[index].docRef}'),
                                        Text(
                                          '${AppLocalizations.of(context)!.translate('date')}: ${snapshot.data[index].ordDate.substring(0, 10)}',
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Text(
                                            '${AppLocalizations.of(context)!.translate('name_lbl')}: ${snapshot.data[index].name}'),
                                        Text(
                                          'IC: ${snapshot.data[index].icNo}',
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Text(
                                          '${AppLocalizations.of(context)!.translate('package_lbl')}: ${snapshot.data[index].packageCode}',
                                        ),
                                        Text(
                                          '${AppLocalizations.of(context)!.translate('price')}: ${snapshot.data[index].tlNettOrdAmt}',
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Text(
                                            'Desc: ${snapshot.data[index].packageDesc}'),
                                        Text(
                                            '${AppLocalizations.of(context)!.translate('service_tax')}: ${snapshot.data[index].tlSerTax}'),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Text(
                                          '${AppLocalizations.of(context)!.translate('status_lbl')}: ${snapshot.data[index].trnStatus}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${AppLocalizations.of(context)!.translate('discount')}: ${double.tryParse(snapshot.data[index].tlDiscAmt)!.toStringAsFixed(2)}',
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        const Text(''),
                                        Text(
                                          '${AppLocalizations.of(context)!.translate('total_lbl')}: ${double.tryParse(snapshot.data[index].tlOrdAmt)!.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  );
                default:
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('get_order_list_fail'),
                    ),
                  );
              }
            },
          ),
          LoadingModel(
            isVisible: isLoading,
          ),
        ],
      ),
    );
  }
}
