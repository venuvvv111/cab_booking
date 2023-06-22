// ignore_for_file: file_names, camel_case_types, sized_box_for_whitespace
import 'package:carousel_slider/carousel_slider.dart';
import 'package:figgocabs/controllers/homescreen_controller.dart';
import 'package:figgocabs/screens/cabservice/cityCab/anywhere/anywhere_screen.dart';
import 'package:figgocabs/screens/cabservice/outstation/outstation_cab_service.dart';
import 'package:figgocabs/screens/common/missing_article_screen.dart';
import 'package:figgocabs/screens/homescreen/package_screen.dart';
import 'package:figgocabs/screens/cabservice/cityCab/city_cab_screen.dart';
import 'package:figgocabs/widgets/category_title.dart';
import 'package:figgocabs/widgets/home_screen_listing_widget.dart';
import 'package:figgocabs/widgets/home_screen_map.dart';
import 'package:figgocabs/widgets/home_screen_services.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var controller = Get.put(HomeScreenController());
  List<String> serviceImages = [
    'assets/images/city-cab.png',
    'assets/images/outstation.png',
    'assets/images/share-cab.png',
    'assets/icons/airportCab.png',
    'assets/icons/royal.png',
    'assets/icons/tour.png',
    'assets/icons/hotel.png',
    'assets/icons/goods.png',
    'assets/icons/flight.png',
    'assets/icons/train.png',
    'assets/icons/microBus.png',
    'assets/icons/more.png'
  ];

  List<String> serviceTitles = [
    'City Cab',
    'Outstation',
    'Share Cab',
    'Airport Cab',
    'Royal Cab',
    'Tour Plan',
    'Hotel',
    'Goods Vehicle',
    'Flight',
    'Train',
    'Micro Bus',
    'More'
  ];

  @override
  void initState() {
    super.initState();
    controller.fetchBanners();
    setStatusBarColor(Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeScreenMap(),
            24.height,
            const CategoryTitle(title: "Book a ride"),
            buildHomeScreenServices(size),
            const CategoryTitle(title: "Offers"),
            Obx(() => controller.isLoading.value
                ? buildShimmerCorosal()
                : buildCorosal()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Obx(() => Container(
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: controller.isLoading.value
                        ? Container()
                        : Image(
                            image: NetworkImage(
                                controller.dashboardModel.data.bankOffer),
                            fit: BoxFit.cover,
                          ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: size.height / 3,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: [
                      const Color(0xFFFFAB02),
                      Colors.yellow.withOpacity(0.6)
                    ])),
                child: const Image(
                  image: AssetImage('assets/images/partner.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            20.height,
            buildHomeScreenListing()
          ],
        ),
      ),
    );
  }

  buildHomeScreenServices(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GridView.builder(
        padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: size.width > 411 ? 4 : 3,
          ),
          shrinkWrap: true,
          itemCount: serviceTitles.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                openPage(index);
              },
              child: HomeScreenServices(
                image: serviceImages[index],
                title: serviceTitles[index],
              ),
            );
          }),
    );
  }

  buildHomeScreenListing() {
    return InkWell(
      onTap: () {
        const PackageScreen().launch(context,
            isNewTask: false, pageRouteAnimation: PageRouteAnimation.Fade);
      },
      child: const HomeScreenListingWidget(
        title: 'Packages',
        subtitle:
            'Refer Figgo app to your family and friends and get rewarded.',
        image: 'assets/images/bottomMenu/menu5.png',
      ),
    );
  }

  buildCorosal() {
    return controller.banners.isNotEmpty
        ? CarouselSlider.builder(
            itemCount: controller.banners.length,
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) =>
                    Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  image: NetworkImage(controller.banners[itemIndex]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            options: CarouselOptions(
              height: 156.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 16,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
          )
        : null;
  }

  buildShimmerCorosal() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.white,
      child: CarouselSlider(
        items: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ],
        options: CarouselOptions(
          height: 156.0,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 16,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 0.8,
        ),
      ),
    );
  }

  void openPage(int index) {
    switch(index){
      case 0 :
        const AnywhereScreen().launch(context,
            isNewTask: false,
            pageRouteAnimation: PageRouteAnimation.Fade);
        break;
      case 1 :
        const OutStationCabService().launch(context,
            isNewTask: false,
            pageRouteAnimation: PageRouteAnimation.Fade);
        break;
      default :
        const MissingArticleScreen().launch(context,
            isNewTask: false,
            pageRouteAnimation: PageRouteAnimation.Fade);


    }
  }
}
