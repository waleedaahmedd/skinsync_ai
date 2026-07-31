
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/responses/payment_options_response.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../utills/date_time_utills.dart';
import '../view_models/checkout_view_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import 'bottom_nav_page.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  static const routeName = '/payment_screen';

  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  // Payment Type options: 'deposit', 'full', 'wallet'
  String _selectedPaymentType = 'deposit';

  // Mock initial wallet balance
  final double _walletBalance = 250.00;
  final double _consultationFee = 150.00;

  Future<void> _bookAppointment() async {
    final checkoutState = ref.read(checkoutViewModel);
    final clinicName =
        checkoutState.selectedClinic?.name ?? "Aesthetic Wellness Clinic";
    final doctorName =
        checkoutState.selectedDoctorObject?.doctorName ?? checkoutState.selectedDoctor?.doctorName ?? "Specialist Doctor";
    final dateStr = checkoutState.selectedDate != null
        ? checkoutState.selectedDate!.formattedDayDate
        : "Not Selected";
    final slotStr = checkoutState.selectedSlot ?? "Not Selected";

    double paidAmount = 0.0;
    String paymentMethodName = "";

    if (_selectedPaymentType == 'deposit') {
      paidAmount = _consultationFee * 0.10;
      paymentMethodName = "10% Security Deposit";
    } else if (_selectedPaymentType == 'full') {
      paidAmount = _consultationFee;
      paymentMethodName = "Full Payment Pre-paid";
    } else {
      paidAmount = _consultationFee;
      paymentMethodName = "Paid via Skinsync Wallet";
    }

    final checkoutNotifier = ref.read(checkoutViewModel.notifier);

    // Set payment option in ViewModel
    final dummyOption = PaymentOption(
      id: _selectedPaymentType == 'deposit'
          ? 1
          : (_selectedPaymentType == 'full' ? 2 : 3),
      title: _selectedPaymentType,
      amount: paidAmount.toInt(),
      description: paymentMethodName,
    );
    checkoutNotifier.setSelectedPaymentOption(dummyOption);

    bool isSuccess = false;

    if (checkoutState.isInviteClinic) {
      final clinic = ref.read(checkoutViewModel).selectedClinic;
      final success = await checkoutNotifier.inviteClinic(
        clinic: clinic!,
        consultationFees: _consultationFee,
        initialDeposit: paidAmount,
        availability: [],
      );
      isSuccess = success ?? false;
    } else {
      // Regular booking via unified API
      await checkoutNotifier.createAppointment();
      isSuccess = ref.read(checkoutViewModel).appointment != null;
    }

    if (isSuccess) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success Crown Check Icon
                    Container(
                      height: 70.w,
                      width: 70.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.shade50,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 44.sp,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      "Booking Successful!",
                      style: CustomFonts.black22w600,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Your consultation session has been secured successfully.",
                      style: CustomFonts.grey12w400,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),

                    // Receipt-style Summary Details card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: CustomColors.lightPurpleColor.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildReceiptRow("Clinic:", clinicName),
                          _buildReceiptRow("Specialist:", doctorName),
                          _buildReceiptRow("Date:", dateStr),
                          _buildReceiptRow("Time Slot:", slotStr),
                          const Divider(height: 20, color: Colors.grey),
                          _buildReceiptRow("Payment Mode:", paymentMethodName),
                          _buildReceiptRow(
                            "Amount Paid:",
                            "\$${paidAmount.toStringAsFixed(2)}",
                            isPrice: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Dismiss and Reset Button (using custom button)
                    CustomButton(
                      text: "Return to Home",
                      borderRadius: 26.r,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      onPressed: () {
                        // Clear the checkoutState context completely
                        ref.read(checkoutViewModel.notifier).clearState();

                        // Route to main Home Screen Bottom nav
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          BottomNavPage.routeName,
                          (_) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildReceiptRow(String label, String value, {bool isPrice = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: CustomFonts.grey12w400.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: isPrice
                  ? CustomFonts.black14w600.copyWith(
                      color: CustomColors.pinkColor,
                    )
                  : CustomFonts.black12w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double depositAmount = _consultationFee * 0.10;
    final double remainingWalletBalance = _walletBalance - _consultationFee;

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: const CustomAppBar(showTitle: true, title: "Payment Type"),
      body: Container(
        decoration: const BoxDecoration(
          gradient: CustomColors.whiteBlueGradient,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Payment Option",
                      style: CustomFonts.black18w600,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "Choose how you would like to secure this medical spa consultation session.",
                      style: CustomFonts.grey12w400,
                    ),
                    SizedBox(height: 20.h),

                    // Option 1: 10% Security Deposit
                    _buildPaymentOptionCard(
                      id: 'deposit',
                      title: "Pay 10% Security Deposit",
                      description:
                          "Secure your slot now by pre-paying a refundable 10% deposit. Pay the balance of \$${(_consultationFee * 0.90).toStringAsFixed(2)} at the clinic.",
                      priceText: "\$${depositAmount.toStringAsFixed(2)}",
                    ),

                    // Option 2: Full Pre-payment
                    _buildPaymentOptionCard(
                      id: 'full',
                      title: "Pay Full Amount",
                      description:
                          "Complete payment in full now for seamless premium checkout when visiting the clinic.",
                      priceText: "\$${_consultationFee.toStringAsFixed(2)}",
                    ),

                    // Option 3: Deduct from Wallet
                    _buildPaymentOptionCard(
                      id: 'wallet',
                      title: "Deduct from Skinsync Wallet",
                      description:
                          "Instantly pay using your pre-funded medical spa wallet. Available balance: \$${_walletBalance.toStringAsFixed(2)}",
                      priceText: "\$${_consultationFee.toStringAsFixed(2)}",
                      extraWidget: _selectedPaymentType == 'wallet'
                          ? Container(
                              margin: EdgeInsets.only(top: 10.h),
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: remainingWalletBalance >= 0
                                    ? Colors.green.shade50
                                    : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    remainingWalletBalance >= 0
                                        ? Icons.check_circle_outline_rounded
                                        : Icons.error_outline_rounded,
                                    color: remainingWalletBalance >= 0
                                        ? Colors.green.shade600
                                        : Colors.red.shade600,
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      remainingWalletBalance >= 0
                                          ? "Sufficient balance! Remaining: \$${remainingWalletBalance.toStringAsFixed(2)}"
                                          : "Insufficient wallet balance. fund wallet to use.",
                                      style: TextStyle(
                                        color: remainingWalletBalance >= 0
                                            ? Colors.green.shade800
                                            : Colors.red.shade800,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),

            // Booking Execution Floating Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: CustomButton(
                text: "Confirm & Secure Consultation",
                borderRadius: 26.r,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                onPressed:
                    (_selectedPaymentType == 'wallet' &&
                        remainingWalletBalance < 0)
                    ? null
                    : _bookAppointment,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOptionCard({
    required String id,
    required String title,
    required String description,
    required String priceText,
    Widget? extraWidget,
  }) {
    final isSelected = _selectedPaymentType == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentType = id;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? CustomColors.pinkColor.withValues(alpha: 0.04)
              : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? CustomColors.pinkColor : Colors.grey.shade200,
            width: isSelected ? 1.8 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.04 : 0.01),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Radio circular state
                Container(
                  height: 20.w,
                  width: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? CustomColors.pinkColor
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            height: 10.w,
                            width: 10.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: CustomColors.pinkColor,
                            ),
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    title,
                    style: isSelected
                        ? CustomFonts.black14w600.copyWith(
                            color: CustomColors.pinkColor,
                          )
                        : CustomFonts.black14w600,
                  ),
                ),
                Text(priceText, style: CustomFonts.black14w600),
              ],
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.only(left: 32.w),
              child: Text(description, style: CustomFonts.grey12w400),
            ),
            if (extraWidget != null)
              Padding(
                padding: EdgeInsets.only(left: 32.w),
                child: extraWidget,
              ),
          ],
        ),
      ),
    );
  }
}
