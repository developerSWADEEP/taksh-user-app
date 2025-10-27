import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/home/widgets/brands_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/highlight_widget.dart';
import 'package:sixam_mart/features/home/widgets/views/top_offers_near_me.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/features/flash_sale/widgets/flash_sale_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/bad_weather_widget.dart';
import 'package:sixam_mart/features/home/widgets/views/product_with_categories_view.dart';
import 'package:sixam_mart/features/home/widgets/views/featured_categories_view.dart';
import 'package:sixam_mart/features/home/widgets/views/popular_store_view.dart';
import 'package:sixam_mart/features/home/widgets/views/item_that_you_love_view.dart';
import 'package:sixam_mart/features/home/widgets/views/just_for_you_view.dart';
import 'package:sixam_mart/features/home/widgets/views/most_popular_item_view.dart';
import 'package:sixam_mart/features/home/widgets/views/new_on_mart_view.dart';
import 'package:sixam_mart/features/home/widgets/views/middle_section_banner_view.dart';
import 'package:sixam_mart/features/home/widgets/views/special_offer_view.dart';
import 'package:sixam_mart/features/home/widgets/views/promotional_banner_view.dart';
import 'package:sixam_mart/features/home/widgets/views/visit_again_view.dart';
import 'package:sixam_mart/features/home/widgets/banner_view.dart';
import 'package:sixam_mart/features/home/widgets/views/category_view.dart';


import '../../../../common/widgets/custom_image.dart';
import '../../../../common/widgets/custom_ink_well.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../../splash/controllers/splash_controller.dart';
import '../../widgets/module_view.dart';

class ShopHomeScreen extends StatelessWidget {
  const ShopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.shopModuleBannerBg),
            fit: BoxFit.cover,
          ),
        ),
        child: const Column(
          children: [
            BadWeatherWidget(),

            BannerView(isFeatured: false),
            SizedBox(height: 12),
          ],
        ),
      ),

      /// module view
      Get.find<SplashController>().moduleList != null ? Get.find<SplashController>().moduleList!.isNotEmpty ? GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: Dimensions.paddingSizeSmall,
          crossAxisSpacing: Dimensions.paddingSizeSmall,
          childAspectRatio: (1/1),
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        itemCount: Get.find<SplashController>().moduleList!.length,
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              color: Theme.of(context).cardColor,
              border: Border.all(color: Theme.of(context).primaryColor, width: 0.15),
              boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.1), spreadRadius: 1, blurRadius: 3)],
            ),
            child: CustomInkWell(
              onTap: () => Get.find<SplashController>().switchModule(index, true),
              radius: Dimensions.radiusDefault,
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImage(
                    image: '${Get.find<SplashController>().moduleList![index].iconFullUrl}',
                    height: 50, width: 50,
                  ),
                ),

                Center(child: Text(
                  Get.find<SplashController>().moduleList![index].moduleName!,
                  textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                )),

              ]),
            ),
          );
        },
      ) : Center(child: Padding(
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall), child: Text('no_module_found'.tr),
      )) : ModuleShimmer(isEnabled: Get.find<SplashController>().moduleList == null),

      const CategoryView(),
      isLoggedIn ? const VisitAgainView() : const SizedBox(),
      const MostPopularItemView(isFood: false, isShop: true),
      const FlashSaleViewWidget(),
      const MiddleSectionBannerView(),
      const HighlightWidget(),
      const PopularStoreView(),
      const BrandsViewWidget(),
      const SpecialOfferView(isFood: false, isShop: true),
      const ProductWithCategoriesView(fromShop: true),
      const JustForYouView(),
      const TopOffersNearMe(),
      const FeaturedCategoriesView(),
      const ItemThatYouLoveView(forShop: true,),
      const NewOnMartView(isShop: true,isPharmacy: false),
      const PromotionalBannerView(),
    ]);
  }
}
