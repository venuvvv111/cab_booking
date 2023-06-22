import 'package:animated_digit/animated_digit.dart';
import 'package:figgocabs/controllers/wallet_controller.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:figgocabs/widgets/bounce_animation.dart';
import 'package:figgocabs/widgets/category_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  var controller = Get.put(WalletController());
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    controller.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  12.height,
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Wallet', style: boldTextStyle(size: 32)),
                  ),
                  Bounce(
                    duration: const Duration(milliseconds: 150),
                    onPressed: () {},
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xff203757), Color(0xff8aafe2)]),
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(2, 2),
                              blurRadius: 8,
                              color: Color.fromRGBO(0, 0, 0, 0.16),
                            )
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Figgo cash',
                                        style: primaryTextStyle(
                                            color: Colors.white, size: 14),
                                      ),
                                      4.height,
                                      Row(
                                        children: [
                                          Text('₹ ',
                                              style: boldTextStyle(
                                                  color: Colors.white,
                                                  size: 42)),
                                          AnimatedDigitWidget(
                                              value:
                                                  controller.walletAmount.value,
                                              enableSeparator: true,
                                              duration:
                                                  const Duration(seconds: 1),
                                              textStyle: boldTextStyle(
                                                  color: Colors.white,
                                                  size: 42)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text(box.read(Constant.name),
                                    style: primaryTextStyle(
                                        color: Colors.white, size: 16)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(
                              'assets/icons/chip.png',
                              width: 50,
                              height: 50,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const CategoryTitle(title: "Wallet Actions"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8, left: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  color: primaryColor.withOpacity(0.78),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              8.height,
                              const FittedBox(child: Text('Add money')),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8, left: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  color: primaryColor.withOpacity(0.78),
                                  child: const Icon(
                                    Icons.payments_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              8.height,
                              const FittedBox(child: Text('Pay')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (controller.walletModel != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CategoryTitle(title: "Activities"),
                        controller.walletModel!.transactions.isNotEmpty
                            ? ListView.builder(
                                itemCount:
                                    controller.walletModel!.transactions.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        16, 0, 16, 16),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 24),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 8,
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.16),
                                          )
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 48,
                                              width: 48,
                                              padding: controller
                                                          .walletModel!
                                                          .transactions[index]
                                                          .mode ==
                                                      "wallet"
                                                  ? const EdgeInsets.all(12)
                                                  : const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                color: const Color(0xff8aafe2),
                                              ),
                                              child: SvgPicture.asset(
                                                  controller
                                                              .walletModel!
                                                              .transactions[
                                                                  index]
                                                              .mode ==
                                                          "upi"
                                                      ? 'assets/icons/upi.svg'
                                                      : controller
                                                                  .walletModel!
                                                                  .transactions[
                                                                      index]
                                                                  .mode ==
                                                              "stripe"
                                                          ? 'assets/icons/stripe.svg'
                                                          : 'assets/icons/wallet.svg',
                                                  fit: BoxFit.contain,
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                          primaryColor,
                                                          BlendMode.srcIn),
                                                  semanticsLabel:
                                                      'A red up arrow'),
                                            ),
                                            12.width,
                                            Text(controller
                                                .walletModel!
                                                .transactions[index]
                                                .transactionId)
                                          ],
                                        ),
                                        Text(
                                          '${controller.walletModel!.transactions[index].transactionType == 'debit' ? '-' : '+'} '
                                          '₹ ${controller.walletModel!.transactions[index].amount}',
                                          style: primaryTextStyle(
                                              color: controller
                                                          .walletModel!
                                                          .transactions[index]
                                                          .transactionType ==
                                                      'debit'
                                                  ? Colors.red.shade700
                                                  : Colors.green.shade700),
                                        )
                                      ],
                                    ),
                                  );
                                })
                            : SizedBox(
                                height: 150,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.monetization_on,
                                    ),
                                    8.width,
                                    Text(
                                      'No Transactions found',
                                      style: primaryTextStyle(),
                                    ),
                                  ],
                                ),
                              )
                      ],
                    ),
                ],
              )),
        ),
      ),
    );
  }
}
