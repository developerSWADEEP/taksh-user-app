import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/features/category/controllers/category_controller.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AvailableServicesScreen extends StatefulWidget {
  final int initialCategoryIndex;
  
  const AvailableServicesScreen({super.key, this.initialCategoryIndex = 0});

  @override
  State<AvailableServicesScreen> createState() => _AvailableServicesScreenState();
}

class _AvailableServicesScreenState extends State<AvailableServicesScreen> {
  late int _selectedCategoryIndex;

  @override
  void initState() {
    super.initState();
    _selectedCategoryIndex = widget.initialCategoryIndex;
    
    // Ensure service categories are loaded
    Get.find<CategoryController>().getServiceCategoryList(false).then((_) {
      // Load subcategories for the selected category
      final categoryController = Get.find<CategoryController>();
      if (categoryController.serviceCategoryList != null && 
          categoryController.serviceCategoryList!.isNotEmpty &&
          _selectedCategoryIndex < categoryController.serviceCategoryList!.length &&
          categoryController.serviceCategoryList![_selectedCategoryIndex].uuid != null) {
        categoryController.getServiceSubCategoryList(categoryController.serviceCategoryList![_selectedCategoryIndex].uuid!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'available_service'.tr,
        showCart: true,
      ),
      body: GetBuilder<CategoryController>(builder: (categoryController) {
        return categoryController.serviceCategoryList != null
            ? Column(
                children: [
                  // Horizontal category list at the top
                  Container(
                    height: 140,
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      itemCount: categoryController.serviceCategoryList!.length,
                      itemBuilder: (context, index) {
                        final category = categoryController.serviceCategoryList![index];
                        final isSelected = _selectedCategoryIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategoryIndex = index;
                            });
                            // Load subcategories for selected category using UUID
                            if (category.uuid != null) {
                              categoryController.getServiceSubCategoryList(category.uuid!);
                            }
                          },
                          child: Container(
                            width: 90,
                            margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                            child: Column(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    child: CustomImage(
                                      image: category.imageFullUrl ?? '',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                Text(
                                  category.name ?? '',
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: isSelected
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).textTheme.bodyMedium?.color,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const Divider(height: 1),

                  // Sub Categories section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Text(
                            'sub_categories'.tr,
                            style: robotoBold.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                          ),
                        ),
                        Expanded(
                          child: categoryController.subCategoryList != null
                              ? categoryController.subCategoryList!.isNotEmpty
                                  ? ListView.builder(
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                      itemCount: categoryController.subCategoryList!.length,
                                      itemBuilder: (context, index) {
                                        final subCategory = categoryController.subCategoryList![index];
                                        return InkWell(
                                          onTap: () {
                                            Get.toNamed(
                                              RouteHelper.getServicesByCategoryRoute(
                                                subCategory.id!,
                                                subCategory.name!,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.1),
                                                  blurRadius: 5,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                                  child: CustomImage(
                                                    image: subCategory.imageFullUrl ?? '',
                                                    height: 80,
                                                    width: 80,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(width: Dimensions.paddingSizeDefault),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        subCategory.name ?? '',
                                                        style: robotoBold.copyWith(
                                                          fontSize: Dimensions.fontSizeDefault,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                                      Text(
                                                        subCategory.description ?? 'We are well-equipped and well-prepared with experts to offer you the best service...',
                                                        style: robotoRegular.copyWith(
                                                          fontSize: Dimensions.fontSizeSmall,
                                                          color: Theme.of(context).disabledColor,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                                      Text(
                                                        '${subCategory.serviceCount ?? 0} ${'services'.tr}',
                                                        style: robotoMedium.copyWith(
                                                          fontSize: Dimensions.fontSizeSmall,
                                                          color: Theme.of(context).primaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Text(
                                        'no_sub_categories_found'.tr,
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                        ),
                                      ),
                                    )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return Shimmer(
                                      duration: const Duration(seconds: 2),
                                      enabled: true,
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        ),
                                        height: 100,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}


