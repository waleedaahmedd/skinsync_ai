import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../utils/date_time_utils.dart';
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
    final checkoutNotifier = ref.read(checkoutViewModel.notifier);

    final bool isSuccess = await checkoutNotifier.bookAppointment(
      selectedPaymentType: _selectedPaymentType,
      consultationFee: _consultationFee,
    );

    if (isSuccess) {
      final checkoutState = ref.read(checkoutViewModel);
      final clinicName = checkoutState.selectedClinic?.name ?? "N/A";
      final doctorName =
          checkoutState.selectedDoctorObject?.doctorName ??
          checkoutState.selectedDoctor?.doctorName ??
          "N/A";
      final dateStr = checkoutState.selectedDate != null
          ? checkoutState.selectedDate!.formattedDayDate
          : "Not Selected";
      final slotStr = checkoutState.selectedSlot ?? "Not Selected";

      final paidAmount = (checkoutState.selectedPaymentOption?.amount ?? 0)
          .toDouble();
      final paymentMethodName =
          checkoutState.selectedPaymentOption?.description ?? "";

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.r(24)),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(24),
                  vertical: context.h(30),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success Crown Check Icon
                    Container(
                      height: context.w(70),
                      width: context.w(70),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.shade50,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: context.sp(44),
                          color: Colors.green.shade600,
                        ),
                      ),
                    ),
                    SizedBox(height: context.h(18)),
                    Text(
                      "Booking Successful!",
                      style: CustomFonts.black22w600,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.h(8)),
                    Text(
                      "Your consultation session has been secured successfully.",
                      style: CustomFonts.grey12w400,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.h(20)),

                    // Receipt-style Summary Details card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(context.w(16)),
                      decoration: BoxDecoration(
                        color: CustomColors.lightPurpleColor.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(context.r(16)),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildReceiptRow("Clinic:", clinicName),
                          _buildReceiptRow("Specialist:", doctorName),
                          _buildReceiptRow("Date:", dateStr),
                          _buildReceiptRow("Time Slot:", slotStr),
                          Divider(height: context.h(20), color: Colors.grey),
                          _buildReceiptRow("Payment Mode:", paymentMethodName),
                          _buildReceiptRow(
                            "Amount Paid:",
                            "\$${paidAmount.toStringAsFixed(2)}",
                            isPrice: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.h(24)),

                    // Dismiss and Reset Button (using custom button)
                    CustomButton(
                      text: "Return to Home",
                      borderRadius: context.r(26),

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
      padding: EdgeInsets.symmetric(vertical: context.h(4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: CustomFonts.grey12w400.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: context.w(8)),
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
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(24),
                  vertical: context.h(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Payment Option",
                      style: CustomFonts.black18w600,
                    ),
                    SizedBox(height: context.h(6)),
                    Text(
                      "Choose how you would like to secure this medical spa consultation session.",
                      style: CustomFonts.grey12w400,
                    ),
                    SizedBox(height: context.h(20)),

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
                              margin: EdgeInsets.only(top: context.h(10)),
                              padding: EdgeInsets.all(context.w(10)),
                              decoration: BoxDecoration(
                                color: remainingWalletBalance >= 0
                                    ? Colors.green.shade50
                                    : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(
                                  context.r(10),
                                ),
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
                                    size: context.sp(16),
                                  ),
                                  SizedBox(width: context.w(8)),
                                  Expanded(
                                    child: Text(
                                      remainingWalletBalance >= 0
                                          ? "Sufficient balance! Remaining: \$${remainingWalletBalance.toStringAsFixed(2)}"
                                          : "Insufficient wallet balance. fund wallet to use.",
                                      style: TextStyle(
                                        color: remainingWalletBalance >= 0
                                            ? Colors.green.shade800
                                            : Colors.red.shade800,
                                        fontSize: context.sp(11),
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
              padding: EdgeInsets.symmetric(
                horizontal: context.w(24),
                vertical: context.h(20),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(context.r(24)),
                ),
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
                borderRadius: context.r(26),

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
        margin: EdgeInsets.only(bottom: context.h(16)),
        padding: EdgeInsets.all(context.w(16)),
        decoration: BoxDecoration(
          color: isSelected
              ? CustomColors.pinkColor.withValues(alpha: 0.04)
              : Colors.white,
          borderRadius: BorderRadius.circular(context.r(20)),
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
                  height: context.w(20),
                  width: context.w(20),
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
                            height: context.w(10),
                            width: context.w(10),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: CustomColors.pinkColor,
                            ),
                          ),
                        )
                      : null,
                ),
                SizedBox(width: context.w(12)),
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
            SizedBox(height: context.h(8)),
            Padding(
              padding: EdgeInsets.only(left: context.w(32)),
              child: Text(description, style: CustomFonts.grey12w400),
            ),
            if (extraWidget != null)
              Padding(
                padding: EdgeInsets.only(left: context.w(32)),
                child: extraWidget,
              ),
          ],
        ),
      ),
    );
  }
}
