import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/hover/text_hover.dart';
import 'package:sixam_mart/common/widgets/ripple_button.dart';
import 'package:sixam_mart/features/category/controllers/category_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AllServiceCategoriesScreen extends StatefulWidget {
  const AllServiceCategoriesScreen({super.key});

  @override
  State<AllServiceCategoriesScreen> createState() => _AllServiceCategoriesScreenState();
}

class _AllServiceCategoriesScreenState extends State<AllServiceCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().getServiceCategoryList(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(
        title: 'all_services'.tr,
        showCart: false,
      ),
      body: GetBuilder<CategoryController>(
        builder: (categoryController) {
          return categoryController.serviceCategoryList != null
              ? categoryController.serviceCategoryList!.isNotEmpty
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Center(
                        child: SizedBox(
                          width: Dimensions.webMaxWidth,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: ResponsiveHelper.isDesktop(context)
                                  ? 10
                                  : ResponsiveHelper.isTab(context)
                                      ? 6
                                      : 4,
                              crossAxisSpacing: Dimensions.paddingSizeSmall,
                              mainAxisSpacing: Dimensions.paddingSizeSmall,
                              childAspectRatio: MediaQuery.of(context).size.width < 400 ? 0.85 : 0.95,
                            ),
                            itemCount: categoryController.serviceCategoryList!.length,
                            itemBuilder: (context, index) {
                              return TextHover(
                                builder: (hovered) {
                                  return Stack(
                                    children: [
                                      Builder(
                                        builder: (context) {
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
                                        },
                                      ),
                                      Positioned.fill(
                                        child: RippleButton(
                                          onTap: () {
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
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                        child: Text(
                          'no_service_categories_found'.tr,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                    )
              : _buildShimmer(context);
        },
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Center(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveHelper.isDesktop(context)
                  ? 10
                  : ResponsiveHelper.isTab(context)
                      ? 6
                      : 4,
              crossAxisSpacing: Dimensions.paddingSizeSmall,
              mainAxisSpacing: Dimensions.paddingSizeSmall,
              childAspectRatio: MediaQuery.of(context).size.width < 400 ? 0.85 : 0.95,
            ),
            itemCount: ResponsiveHelper.isDesktop(context)
                ? 20
                : ResponsiveHelper.isTab(context)
                    ? 18
                    : 12,
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
          ),
        ),
      ),
    );
  }
}


