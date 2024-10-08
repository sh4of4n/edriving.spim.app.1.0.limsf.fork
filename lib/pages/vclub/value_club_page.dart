

import 'package:auto_route/auto_route.dart';
import 'package:badges/badges.dart' as badges;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:edriving_spim_app/pages/epandu/bottom_menu.dart';
import '/common_library/utils/app_localizations.dart';
import '/services/provider/cart_status.dart';
import '/common_library/services/repository/products_repository.dart';
import '/common_library/services/repository/sales_order_repository.dart';
import '/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../router.gr.dart';
@RoutePage()
class ValueClub extends StatefulWidget {
  const ValueClub({super.key});

  @override
  ValueClubState createState() => ValueClubState();
}

class ValueClubState extends State<ValueClub> {
  static final myImage = ImagesConstant();
  final formatter = NumberFormat('#,##0.00');

  final productsRepo = ProductsRepo();
  final salesOrderRepo = SalesOrderRepo();

  int _carouselIndex = 0;

  dynamic mostPopularProducts;
  dynamic recommendedProducts;
  List<String> categoryItems = [
    'Women\'s Clothing',
    'Electronics',
    'Toys',
    'Beauty',
    'Home Appliances',
    'Sports',
    'Gaming'
  ];

  bool mostPopularLoading = false;
  bool recommendedLoading = false;

  TextStyle headerBubble = TextStyle(
    fontSize: 66.sp,
    fontWeight: FontWeight.w600,
    color: Colors.grey[800],
  );

  TextStyle shopMore = TextStyle(
    fontSize: 60.sp,
    fontWeight: FontWeight.w500,
    color: Colors.blue,
  );

  final bubbleDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: const [
      BoxShadow(
        color: Colors.black26,
        offset: Offset(0.0, 5.0),
        blurRadius: 7.0,
      ),
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0.0, -5.0),
        blurRadius: 5.0,
      ),
    ],
  );

  final RegExp removeBracket =
      RegExp("\\[(.*?)\\]", multiLine: true, caseSensitive: true);

  final banners = [
    myImage.amaron,
    myImage.apollo,
    myImage.bhl,
    myImage.castrol,
    myImage.century,
    myImage.jrd,
    myImage.total,
    myImage.westlake,
  ];

  final brands = [
    myImage.carserLogo,
    myImage.eSalesLogo,
    myImage.mobileWarehouseLogo,
  ];

  @override
  void initState() {
    super.initState();

    Future.wait([
      _mostPopular('WL-%20LT', 6),
      _recommended('WL-OTR', 9),
    ]);

    _getActiveSlsTrnByDb();
  }

  Future<dynamic> _getActiveSlsTrnByDb() async {
    var result = await salesOrderRepo.getActiveSlsTrnByDb(
      context: context,
      dbcode: 'TBS',
      isCart: 'true',
    );

    if (mounted) {
      if (result.isSuccess) {
        // return result.data;
        _getSlsDetailByDocNo(
          context,
          result.data[0].docDoc,
          result.data[0].docRef,
        );
      }
    }
  }

  Future<dynamic> _getSlsDetailByDocNo(context, docDoc, docRef) async {
    var result = await salesOrderRepo.getSlsDetailByDocNo(
      context: context,
      docDoc: docDoc,
      docRef: docRef,
    );

    if (result.isSuccess && mounted) {
      /* setState(() {
        _showBadge = true;
        // cartItems = result.data.length.toString();
      }); */

      Provider.of<CartStatus>(context, listen: false).setShowBadge(
        showBadge: true,
      );

      Provider.of<CartStatus>(context, listen: false).updateCartBadge(
        cartItem: result.data.length,
      );
    }
  }

  Future<void> _mostPopular(stkCat, endLimit) async {
    setState(() {
      mostPopularLoading = true;
    });

    var result = await productsRepo.getStock(
        context: context,
        stkCat: stkCat,
        keywordSearch: '',
        bgnLimit: 0,
        endLimit: endLimit);

    if (result.isSuccess) {
      setState(() {
        mostPopularProducts = result.data;
      });
    }

    setState(() {
      mostPopularLoading = false;
    });
  }

  Future<void> _recommended(stkCat, endLimit) async {
    setState(() {
      recommendedLoading = true;
    });

    var result = await productsRepo.getStock(
        context: context,
        stkCat: stkCat,
        keywordSearch: '',
        bgnLimit: 0,
        endLimit: endLimit);

    if (result.isSuccess) {
      setState(() {
        recommendedProducts = result.data;
      });
    }

    setState(() {
      recommendedLoading = false;
    });
  }

  loadImage(image) {
    if (image != null) {
      return Image.network(
        image.replaceAll(removeBracket, '').split('\r\n')[0],
        height: 300.h,
        gaplessPlayback: true,
      );
    }

    return SizedBox(
      // width: 180.w,
      height: 300.h,
      child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
    );
  }

  mostPopularList() {
    if (mostPopularProducts != null) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 40.w),
        decoration: bubbleDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 60.w, top: 40.h, right: 60.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Most Popular',
                    style: headerBubble,
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () => context.router.push(
                      ProductList(
                        stkCat: 'WL- LT',
                        keywordSearch: '',
                      ),
                    ),
                    child: Text('Shop More >', style: shopMore),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  // childAspectRatio: MediaQuery.of(context).size.height / 530,
                ),
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                physics: const BouncingScrollPhysics(),
                itemCount: mostPopularProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () => context.router.push(
                      Product(
                        image: mostPopularProducts[index].stkpicturePath != null
                            ? mostPopularProducts[index]
                                .stkpicturePath
                                .replaceAll(removeBracket, '')
                                .split('\r\n')[0]
                            : '',
                        price: mostPopularProducts[index].stkpriceUnitPrice,
                        qty: double.tryParse(mostPopularProducts[index]
                                    .stkqtyYtdAvailableQty) !=
                                null
                            ? formatter.format(double.tryParse(
                                mostPopularProducts[index]
                                    .stkqtyYtdAvailableQty))
                            : mostPopularProducts[index].stkqtyYtdAvailableQty,
                        stkCode: mostPopularProducts[index].stkCode,
                        stkDesc1: mostPopularProducts[index].stkDesc1,
                        stkDesc2: mostPopularProducts[index].stkDesc2,
                        uom: mostPopularProducts[index].uom,
                        products: mostPopularProducts,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        loadImage(mostPopularProducts[index].stkpicturePath),
                        SizedBox(height: 20.h),
                        SizedBox(
                            width: 220.w,
                            child: Text(
                              mostPopularProducts[index].stkCode,
                              maxLines: 1,
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else if (mostPopularProducts == null && mostPopularLoading == true) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.white,
          child: Container(
            width: ScreenUtil().setWidth(1400),
            height: ScreenUtil().setHeight(700),
            color: Colors.grey[300],
          ),
        ),
      );
    }
    return Container();
  }

  recommendedList() {
    if (recommendedProducts != null) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 40.w),
        decoration: bubbleDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 60.w, top: 40.h, right: 60.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recommended',
                    style: headerBubble,
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () => context.router.push(
                      ProductList(
                        stkCat: 'WL- OTR',
                        keywordSearch: '',
                      ),
                    ),
                    child: Text('Shop More >', style: shopMore),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                physics: const BouncingScrollPhysics(),
                itemCount: recommendedProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () => context.router.push(
                      Product(
                        image: recommendedProducts[index].stkpicturePath != null
                            ? recommendedProducts[index]
                                .stkpicturePath
                                .replaceAll(removeBracket, '')
                                .split('\r\n')[0]
                            : '',
                        price: recommendedProducts[index].stkpriceUnitPrice,
                        qty: double.tryParse(recommendedProducts[index]
                                    .stkqtyYtdAvailableQty) !=
                                null
                            ? formatter.format(double.tryParse(
                                recommendedProducts[index]
                                    .stkqtyYtdAvailableQty))
                            : recommendedProducts[index].stkqtyYtdAvailableQty,
                        stkCode: recommendedProducts[index].stkCode,
                        stkDesc1: recommendedProducts[index].stkDesc1,
                        stkDesc2: recommendedProducts[index].stkDesc2,
                        uom: recommendedProducts[index].uom,
                        products: recommendedProducts,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        loadImage(recommendedProducts[index].stkpicturePath),
                        SizedBox(height: 30.h),
                        SizedBox(
                            width: 220.w,
                            child: Text(
                              recommendedProducts[index].stkCode,
                              maxLines: 1,
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else if (recommendedProducts == null && recommendedLoading == true) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.white,
          child: Container(
            width: ScreenUtil().setWidth(1400),
            height: ScreenUtil().setHeight(800),
            color: Colors.grey[300],
          ),
        ),
      );
    }
    return Container();
  }

  categories() {
    if (mostPopularProducts != null) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.0, 5.0),
              blurRadius: 7.0,
            ),
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, -5.0),
              blurRadius: 5.0,
            ),
          ],
        ),
        width: ScreenUtil().screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 60.w, top: 40.h, right: 60.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: headerBubble,
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () => context.router.push(
                      ProductList(
                        stkCat: 'WL- LT',
                        keywordSearch: '',
                      ),
                    ),
                    child: Text('Shop More >', style: shopMore),
                  ),
                ],
              ),
            ),
            Container(
              height: 1200.h,
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // childAspectRatio: MediaQuery.of(context).size.height / 530,
                ),
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                // physics: BouncingScrollPhysics(),
                itemCount: categoryItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    /* onTap: () => context.router.push(
                      Routes.product,
                      arguments: ProductArguments(
                        image: mostPopularProducts[index].stkpicturePath != null
                            ? mostPopularProducts[index]
                                .stkpicturePath
                                .replaceAll(removeBracket, '')
                                .split('\r\n')[0]
                            : '',
                        price: mostPopularProducts[index].stkpriceUnitPrice,
                        qty: double.tryParse(mostPopularProducts[index]
                                    .stkqtyYtdAvailableQty) !=
                                null
                            ? formatter.format(double.tryParse(
                                mostPopularProducts[index]
                                    .stkqtyYtdAvailableQty))
                            : mostPopularProducts[index].stkqtyYtdAvailableQty,
                        stkCode: mostPopularProducts[index].stkCode,
                        stkDesc1: mostPopularProducts[index].stkDesc1,
                        stkDesc2: mostPopularProducts[index].stkDesc2,
                        uom: mostPopularProducts[index].uom,
                        products: mostPopularProducts,
                      ),
                    ), */
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // loadImage(mostPopularProducts[index].stkpicturePath),
                        SizedBox(height: 20.h),
                        SizedBox(
                            width: 220.w,
                            child: Text(
                              categoryItems[index],
                              maxLines: 1,
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else if (mostPopularProducts == null && mostPopularLoading == true) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.white,
          child: Container(
            width: ScreenUtil().setWidth(1400),
            height: ScreenUtil().setHeight(700),
            color: Colors.grey[300],
          ),
        ),
      );
    }
    return Container();
  }

  brandList() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 500.h,
        aspectRatio: 16 / 9,
        viewportFraction: 0.5,
        initialPage: _carouselIndex,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 10),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index, reason) {
          setState(() {
            _carouselIndex = index;
          });
        },
      ),
      items: brands.map((banner) {
        return Builder(
          builder: (BuildContext context) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              // margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: Image.asset(banner),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool showBadge = context.watch<CartStatus>().showBadge;
    int? badgeNo = context.watch<CartStatus>().cartItem;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            ColorConstant.primaryColor,
          ],
          stops: [0.45, 0.65],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.translate('value_club')),
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 232, 186, 4),
          actions: [
            InkWell(
              onTap: () => context.router.push(
                Cart(
                  dbcode: 'TBS',
                  itemName: 'TBS',
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 30.h, right: 50.w, bottom: 20.h),
                child: badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: Colors.redAccent[700]!,
                  ),
                  badgeAnimation: const badges.BadgeAnimation.fade(),
                  showBadge: showBadge,
                  badgeContent: Text(
                    '$badgeNo',
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: const Icon(Icons.shopping_cart),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomMenu(),
        body: ListView(
          children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                          child: InkWell(
                            onTap: () =>
                                context.router.push(MerchantList(merchantType: 'HOCHIAK')),
                            child: FadeInImage(
                              alignment: Alignment.center,
                              placeholder: MemoryImage(kTransparentImage),
                              height: ScreenUtil().setHeight(500),
                              image: AssetImage(
                                myImage.hochiak,
                              ),
                            ),
                          ),
                        ),
                         Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                                child: InkWell(
                                  onTap: () => context.router.push(MerchantList(merchantType: 'TOUR')),
                                  child: FadeInImage(
                                    alignment: Alignment.center,
                                    placeholder: MemoryImage(kTransparentImage),
                                    height: ScreenUtil().setHeight(500),
                                    image: AssetImage(
                                      myImage.tourism,
                                    ),
                                  ),
                                ),
                              ),
                        Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                            child: InkWell(
                              onTap: () => context.router.push(MerchantList(merchantType: 'HIGHEDU')),
                              child: FadeInImage(
                                alignment: Alignment.center,
                                placeholder: MemoryImage(kTransparentImage),
                                height: ScreenUtil().setHeight(500),
                                image: AssetImage(
                                  myImage.higherEducation,
                                ),
                              ),
                            ),
                          ),
                      
                     
                      /* Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                        child: InkWell(
                          onTap: () => context.router.push(MerchantList(merchantType: 'JOB')),
                          child: FadeInImage(
                            alignment: Alignment.center,
                            placeholder: MemoryImage(kTransparentImage),
                            height: ScreenUtil().setHeight(500),
                            image: AssetImage(
                              myImage.jobs,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                        child: InkWell(
                          onTap: () => context.router.push(MerchantList(merchantType: 'RIDE')),
                          child: FadeInImage(
                            alignment: Alignment.center,
                            placeholder: MemoryImage(kTransparentImage),
                            height: ScreenUtil().setHeight(500),
                            image: AssetImage(
                              myImage.rideSharing,
                            ),
                          ),
                        ),
                      ), */
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                        child: InkWell(
                          onTap: () => context.router.push(MerchantList(merchantType: 'DI')),
                          child: FadeInImage(
                            alignment: Alignment.center,
                            placeholder: MemoryImage(kTransparentImage),
                            height: ScreenUtil().setHeight(500),
                            image: AssetImage(
                              myImage.drivingSchools,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                        child: InkWell(
                          onTap: () => context.router.push(MerchantList(merchantType: 'WORKSHOP')),
                          child: FadeInImage(
                            alignment: Alignment.center,
                            placeholder: MemoryImage(kTransparentImage),
                            height: ScreenUtil().setHeight(500),
                            image: AssetImage(
                              myImage.workshops,
                            ),
                          ),
                        ),
                      ),
                      ],
                    ),
                ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 800.h,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: _carouselIndex,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 10),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _carouselIndex = index;
                        });
                      },
                    ),
                    items: banners.map((banner) {
                      return Builder(
                        builder: (BuildContext context) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            // margin: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Image.asset(banner),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 90,
                  child: AnimatedSmoothIndicator(
                    activeIndex: _carouselIndex,
                    count: banners.length,
                    effect: const ExpandingDotsEffect(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            mostPopularList(),
            SizedBox(height: 70.h),
            recommendedList(),
            SizedBox(height: 70.h),
            categories(),
            SizedBox(height: 150.h),
            brandList(),
            SizedBox(height: 70.h),
          ],
        ),
      ),
    );
  }
}

/* Container(
              margin: EdgeInsets.symmetric(horizontal: 60.w),
              child: FadeInImage(
                alignment: Alignment.center,
                placeholder: MemoryImage(kTransparentImage),
                // height: ScreenUtil().setHeight(100),
                image: AssetImage(
                  myImage.vClubBanner,
                ),
              ),
            ),
            SizedBox(
              height: 60.h,
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xffbfd730),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 30.w),
              margin: EdgeInsets.symmetric(horizontal: 60.w),
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  // childAspectRatio: MediaQuery.of(context).size.height / 530,
                ),
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  
                ],
              ),
            ), */
