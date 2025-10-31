import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/item_view.dart';
import 'package:sixam_mart/common/widgets/no_data_screen.dart';
import 'package:sixam_mart/features/category/controllers/category_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../common/widgets/item_widget.dart';

class ServicesByCategoryScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  const ServicesByCategoryScreen({super.key, required this.categoryID, required this.categoryName});

  @override
  State<ServicesByCategoryScreen> createState() => _ServicesByCategoryScreenState();
}

class _ServicesByCategoryScreenState extends State<ServicesByCategoryScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch category items (services) for the selected category
    Get.find<CategoryController>().getCategoryItemList(widget.categoryID, 1, 'all', true);
    
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        int totalSize = Get.find<CategoryController>().pageSize!;
        int offset = Get.find<CategoryController>().offset;
        if (offset < totalSize) {
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryItemList(widget.categoryID, offset + 1, Get.find<CategoryController>().type, false);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      List<Item>? serviceList = categoryController.categoryItemList;
      
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: CustomAppBar(
          title: widget.categoryName,
          showCart: true,
        ),
        body: serviceList != null
            ? serviceList.isNotEmpty
                ? SingleChildScrollView(
                    controller: scrollController,
                    child: Center(
                      child: SizedBox(
                        width: Dimensions.webMaxWidth,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: ResponsiveHelper.isMobile(context)
                                      ? 2
                                      : ResponsiveHelper.isTab(context)
                                          ? 3
                                          : 5,
                                  crossAxisSpacing: Dimensions.paddingSizeDefault,
                                  mainAxisSpacing: Dimensions.paddingSizeDefault,
                                  childAspectRatio: ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isTab(context) ? 0.9 : 0.75,
                                  mainAxisExtent: 240,
                                ),
                                itemCount: serviceList.length,
                                itemBuilder: (context, index) {
                                  return ItemWidget(
                                    item: serviceList[index],
                                    isStore: false,
                                    store: null,
                                    index: index,
                                    length: serviceList.length,
                                    isCampaign: false,
                                    inStore: false,
                                  );
                                },
                              ),
                            ),
                            categoryController.isLoading
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: NoDataScreen(
                      text: 'no_service_found'.tr,
                    ),
                  )
            : _buildShimmer(context),
      );
    });
  }

  Widget _buildShimmer(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveHelper.isMobile(context)
                    ? 2
                    : ResponsiveHelper.isTab(context)
                        ? 3
                        : 5,
                crossAxisSpacing: Dimensions.paddingSizeDefault,
                mainAxisSpacing: Dimensions.paddingSizeDefault,
                childAspectRatio: ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isTab(context) ? 1 : 0.70,
              ),
              itemCount: 10,
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
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              color: Theme.of(context).shadowColor,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        Container(
                          height: 15,
                          decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
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
      ),
    );
  }
}
