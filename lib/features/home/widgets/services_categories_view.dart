import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/hover/text_hover.dart';
import 'package:sixam_mart/common/widgets/ripple_button.dart';
import 'package:sixam_mart/common/widgets/title_widget.dart';
import 'package:sixam_mart/features/category/controllers/category_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ServicesCategoriesView extends StatelessWidget {
  const ServicesCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
      initState: (state) {
        Get.find<CategoryController>().getServiceCategoryList(true);
      },
      builder: (categoryController) {
        return categoryController.serviceCategoryList != null && categoryController.serviceCategoryList!.isEmpty
            ? const SizedBox()
            : categoryController.serviceCategoryList != null
                ? Center(
                    child: SizedBox(
                      width: Dimensions.webMaxWidth,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'categories'.tr,
                                    style: robotoBold.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // Navigate to Available Service screen (with horizontal categories + subcategories)
                                      Get.toNamed(RouteHelper.getAvailableServicesRoute());
                                    },
                                    child: Text(
                                      'see_all'.tr,
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeDefault),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4, // Always 4 columns
                                  crossAxisSpacing: Dimensions.paddingSizeSmall,
                                  mainAxisSpacing: Dimensions.paddingSizeSmall,
                                  childAspectRatio: 0.85,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: categoryController.serviceCategoryList!.length > 8 
                                    ? 8 
                                    : categoryController.serviceCategoryList!.length, // Show max 8 items (2x4)
                              itemBuilder: (context, index) {
                                return TextHover(builder: (hovered) {
                                  return Stack(
                                    children: [
                                      Builder(builder: (context) {
                                        final isDark = Theme.of(context).brightness == Brightness.dark;
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? Theme.of(context).cardColor
                                                : Theme.of(context).colorScheme.primary.withOpacity(hovered ? 0.1 : 0.06),
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(Dimensions.radiusDefault),
                                            ),
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: (ResponsiveHelper.isMobile(context) || (kIsWeb && hovered))
                                                      ? Dimensions.paddingSizeSmall + 3
                                                      : Dimensions.paddingSizeDefault,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                                      child: CustomImage(
                                                        image: categoryController.serviceCategoryList?[index].imageFullUrl ?? "",
                                                        fit: BoxFit.fitHeight,
                                                        height: double.infinity,
                                                        width: double.infinity,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: (ResponsiveHelper.isMobile(context) || (kIsWeb && hovered))
                                                      ? Dimensions.paddingSizeSmall + 3
                                                      : Dimensions.paddingSizeDefault,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                                    child: Text(
                                                      categoryController.serviceCategoryList![index].name!,
                                                      style: robotoRegular.copyWith(
                                                        fontSize: Dimensions.fontSizeSmall,
                                                        color: hovered
                                                            ? Get.isDarkMode
                                                                ? Theme.of(context).textTheme.bodyMedium?.color
                                                                : Theme.of(context).colorScheme.primary
                                                            : Theme.of(context).textTheme.bodySmall?.color,
                                                      ),
                                                      maxLines: 2,
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                      Positioned.fill(
                                        child: RippleButton(
                                          onTap: () {
                                            // Navigate to services in that category
                                            Get.toNamed(
                                              RouteHelper.getServicesByCategoryRoute(
                                                categoryController.serviceCategoryList![index].id!,
                                                categoryController.serviceCategoryList![index].name!,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                });
                              },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const ServiceCategoryShimmer();
      },
    );
  }
}

class ServiceCategoryShimmer extends StatelessWidget {
  final bool? fromHomeScreen;

  const ServiceCategoryShimmer({super.key, this.fromHomeScreen = true});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: Column(
          children: [
            if (fromHomeScreen!) const SizedBox(height: Dimensions.paddingSizeLarge),
            if (fromHomeScreen!)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 25,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                  ),
                  Container(
                    height: 25,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                  ),
                ],
              ),
            if (fromHomeScreen!) const SizedBox(height: Dimensions.paddingSizeSmall),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: !fromHomeScreen!
                  ? 8
                  : ResponsiveHelper.isDesktop(context)
                      ? 10
                      : ResponsiveHelper.isTab(context)
                          ? 12
                          : 8,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Shimmer(
                    duration: const Duration(seconds: 2),
                    enabled: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              color: Theme.of(context).shadowColor,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                      ],
                    ),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: !fromHomeScreen!
                    ? 8
                    : ResponsiveHelper.isDesktop(context)
                        ? 10
                        : ResponsiveHelper.isTab(context)
                            ? 6
                            : 4,
                crossAxisSpacing: Dimensions.paddingSizeSmall + 2,
                mainAxisSpacing: Dimensions.paddingSizeSmall + 2,
                childAspectRatio: 1,
              ),
            ),
            SizedBox(height: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeLarge),
          ],
        ),
      ),
    );
  }
}
