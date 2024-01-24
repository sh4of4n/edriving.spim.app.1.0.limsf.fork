import 'package:auto_route/auto_route.dart';
import 'package:edriving_spim_app/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class RootRouter extends $RootRouter {

  @override
  final List<AutoRoute> routes = [
    AutoRoute(path: '/', page: Authentication.page),
    AutoRoute(
        path: '/clientAccount', page: ClientAccount.page/* , name: 'ClientAccount' */),
    AutoRoute(page: Login.page/* , name: 'Login' */),
    AutoRoute(page: ForgotPassword.page/* , name: 'ForgotPassword' */),
    AutoRoute(page: ChangePassword.page/* , name: 'ChangePassword' */),
    AutoRoute(page: RegisterMobile.page/* , name: 'RegisterMobile' */),
    AutoRoute(page: RegisterVerification.page/*, name: 'RegisterVerification' */),
    AutoRoute(page: RegisterForm.page/* , name: 'RegisterForm' */),
    AutoRoute(page: Home.page/* , name: 'Home' */),
    AutoRoute(page: QueueNumber.page/* , name: 'QueueNumber' */),
    AutoRoute(page: Enrollment.page/* , name: 'Enrollment' */),
    AutoRoute(page: DiEnrollment.page/* , name: 'DiEnrollment' */),
    AutoRoute(page: EnrollConfirmation.page/* ,name: 'EnrollConfirmation' */),
    AutoRoute(page: OrderList.page/* , name: 'OrderList' */),
    AutoRoute(page: BankList.page/* , name: 'BankList' */),
    AutoRoute(page: PaymentStatus.page/* , name: 'PaymentStatus' */),
    AutoRoute(page: KppCategory.page/* , name: 'KppCategory' */),
    AutoRoute(page: KppResult.page/* , name: 'KppResult' */),
    AutoRoute(page: KppExam.page/* , name: 'KppExam' */),
    AutoRoute(page: KppModule.page/* , name: 'KppModule' */),
    AutoRoute(page: PinActivation.page/* , name: 'PinActivation' */),
    AutoRoute(page: ValueClub.page/* , name: 'ValueClub' */),
    AutoRoute(page: Product.page/* , name: 'Product' */),
    AutoRoute(page: ProductList.page/* , name: 'ProductList' */),
    AutoRoute(page: Cart.page/* , name: 'Cart' */),
    AutoRoute(page: CartItemEdit.page/* , name: 'CartItemEdit' */),
    AutoRoute(page: Checkout.page/* , name: 'Checkout' */),
    AutoRoute(page: EpanduCategory.page/* , name: 'EpanduCategory' */),
    AutoRoute(page: EtestingCategory.page/* ,name: 'EtestingCategory' */),
    AutoRoute(page: EmergencyDirectory.page/* ,name: 'EmergencyDirectory' */),
    AutoRoute(page: DirectoryList.page/* , name: 'DirectoryList' */),
    AutoRoute(page: DirectoryDetail.page/* ,name: 'DirectoryDetail' */),
    AutoRoute(page: SelectInstitute.page/* ,name: 'SelectInstitute' */),
    AutoRoute(page: SelectClass.page/* , name: 'SelectClass' */),
    AutoRoute(page: SelectDrivingInstitute.page/* ,name: 'SelectDrivingInstitute' */),
    AutoRoute(page: TakeProfilePicture.page/* ,name: 'TakeProfilePicture' */),
    AutoRoute(page: Booking.page/* , name: 'Booking' */),
    AutoRoute(page: AddBooking.page/* , name: 'AddBooking' */),
    AutoRoute(page: Records.page/* , name: 'Records' */),
    AutoRoute(page: Pay.page/* , name: 'Pay' */),
    AutoRoute(page: PurchaseOrderList.page/* ,name: 'PurchaseOrderList' */),
    AutoRoute(page: PaymentHistory.page/* , name: 'PaymentHistory' */),
    AutoRoute(page: PaymentHistoryDetail.page/* ,name: 'PaymentHistoryDetail' */),
    AutoRoute(page: RequestPickup.page/* , name: 'RequestPickup' */),
    AutoRoute(page: RegisteredCourse.page/* ,name: 'RegisteredCourse' */),
    AutoRoute(page: RegisteredCourseDetail.page/* ,name: 'RegisteredCourseDetail' */),
    AutoRoute(page: AttendanceRecord.page/* ,name: 'AttendanceRecord' */),
    AutoRoute(page: AttendanceTab.page/* , name: 'AttendanceTab' */),
    AutoRoute(page: Promotions.page/* , name: 'Promotions' */),
    AutoRoute(page: Profile.page/* , name: 'Profile' */),
    AutoRoute(page: ProfileTab.page/* , name: 'ProfileTab' */),
    AutoRoute(page: UpdateProfile.page/* , name: 'UpdateProfile' */),
    AutoRoute(page: RegisterUserToDi.page/* ,name: 'RegisterUserToDi' */),
    AutoRoute(page: IdentityBarcode.page/* ,name: 'IdentityBarcode' */),
    AutoRoute(page: EnrolmentInfo.page/* , name: 'EnrolmentInfo' */),
    AutoRoute(page: EnrolmentInfoDetail.page/* ,name: 'EnrolmentInfoDetail' */),
    AutoRoute(page: Inbox.page/* , name: 'Inbox' */),
    AutoRoute(page: Invite.page/* , name: 'Invite' */),
    AutoRoute(page: AirtimeTransaction.page/* ,name: 'AirtimeTransaction' */),
    AutoRoute(page: AirtimeBillDetail.page/* ,name: 'AirtimeBillDetail' */),
    AutoRoute(page: AirtimeSelection.page/* ,name: 'AirtimeSelection' */),
    AutoRoute(page: BillTransaction.page/* ,name: 'BillTransaction' */),
    AutoRoute(page: BillDetail.page/* , name: 'BillDetail' */),
    AutoRoute(page: BillSelection.page/* , name: 'BillSelection' */),
    AutoRoute(page: MerchantList.page/* , name: 'MerchantList' */),
    AutoRoute(page: TermsAndCondition.page/* ,name: 'TermsAndCondition' */),
    AutoRoute(page: FpxPaymentOption.page/* ,name: 'FpxPaymentOption' */),
    AutoRoute(page: ImageViewer.page/* , name: 'ImageViewer' */),
    AutoRoute(page: Webview.page/* , name: 'Webview' */),
    AutoRoute(page: Scan.page/* , name: 'Scan' */),
    AutoRoute(page: ReadMore.page/* , name: 'ReadMore' */),
    AutoRoute(page: ViewPdf.page/* , name: 'ViewPdf' */),
    AutoRoute(page: ComingSoon.page/* , name: 'ComingSoon' */),
    AutoRoute(page: CheckInSlip.page/* , name: 'CheckInSlip' */),
    AutoRoute(page: Multilevel.page/* , name: 'Multilevel' */),
    AutoRoute(page: MerchantProfile.page/* ,name: 'MerchantProfile' */),
    AutoRoute(path: '/vehicle', page: Vehicle.page),
    AutoRoute(page: TrainerSchedule.page),
    AutoRoute(page: MapScreen.page),
    AutoRoute(page: Class.page),
    AutoRoute(page: TodayClass.page),
    AutoRoute(page: HistoryClass.page),
    AutoRoute(page: ProgressClass.page),
    AutoRoute(page: AddClass.page),
    AutoRoute(page: MyKad.page),
    AutoRoute(page: Nfc.page),
    AutoRoute(page: Students.page),
    AutoRoute(page: Thumbout.page)
  ];
}
class $AppRouter {}
