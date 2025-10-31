import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sixam_mart/api/local_client.dart';
import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/features/category/domain/models/category_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/features/category/domain/reposotories/category_repository_interface.dart';

class CategoryRepository implements CategoryRepositoryInterface {
  final ApiClient apiClient;
  CategoryRepository({required this.apiClient});
  
  // Helper method to convert UUID string to integer for compatibility
  int _parseIdToInt(dynamic id) {
    if (id == null) return 0;
    if (id is int) return id;
    if (id is String) {
      // Create a hash from UUID string for consistent integer ID
      return id.hashCode.abs();
    }
    return 0;
  }

  @override
  Future getList({int? offset, bool categoryList = false, bool subCategoryList = false, bool categoryItemList = false, bool categoryStoreList = false,
    bool? allCategory, String? id, String? type, DataSourceEnum? source, bool serviceCategoryList = false}) async {
    if (categoryList) {
      return await _getCategoryList(allCategory!, source ?? DataSourceEnum.client);
    } else if (serviceCategoryList) {
      return await _getServiceCategoryList(source ?? DataSourceEnum.client);
    } else if (subCategoryList) {
      return await _getSubCategoryList(id);
    } else if (categoryItemList) {
      return await _getCategoryItemList(id, offset!, type!);
    } else if (categoryStoreList) {
return await _getCategoryStoreList(id, offset!, type!);
    }
  }
  
  Future<List<CategoryModel>?> _getServiceCategoryList(DataSourceEnum source) async {
    List<CategoryModel>? categoryList;
    
    switch(source) {
      case DataSourceEnum.client:
        try {
          // Using Demandium API endpoint - making direct HTTP call since it's a different domain
          // Demandium API requires: zoneid, guest_id, X-localization headers
          String url = '${AppConstants.demandiumBaseUrl}${AppConstants.serviceCategoryUri}?limit=100&offset=1';
          
          print('🔍 Fetching service categories from: $url');
          
          // Prepare headers with required zone and guest info
          Map<String, String> headers = {
            'Content-Type': 'application/json; charset=UTF-8',
            'X-localization': Get.find<LocalizationController>().locale.languageCode,
            'zoneid': '6e3ce413-462e-4f11-9e79-fc6b761c82d3', // Default: "All over the World" zone
            'guest_id': '1', // Guest user ID
          };
          
          print('📤 Request headers: $headers');
          
          http.Response response = await http.get(
            Uri.parse(url),
            headers: headers,
          ).timeout(const Duration(seconds: 30));
            
          print('📡 Response status: ${response.statusCode}');
          
          if (response.statusCode == 200) {
            var decodedBody = jsonDecode(response.body);
            print('📦 Response body keys: ${decodedBody.keys}');
            
            if (decodedBody['content'] != null && decodedBody['content']['data'] != null) {
              var data = decodedBody['content']['data'];
              print('✅ Data found - Count: ${data.length}');
              
              if (data.isNotEmpty) {
                print('📝 First category sample: ${jsonEncode(data[0])}');
                
                categoryList = [];
                for (var category in data) {
                  try {
                    // Transform Demandium format to match CategoryModel
                    Map<String, dynamic> transformedCategory = {
                      'id': _parseIdToInt(category['id']), // Convert UUID string to hash int
                      'name': category['name'],
                      'parent_id': category['parent_id'] == '0' ? 0 : _parseIdToInt(category['parent_id']),
                      'position': category['position'],
                      'created_at': category['created_at'],
                      'updated_at': category['updated_at'],
                      'image_full_url': category['image_full_path'], // Demandium uses image_full_path
                    };
                    
                    categoryList.add(CategoryModel.fromJson(transformedCategory));
                  } catch (e) {
                    print('❌ Error parsing category: $e');
                    print('   Category data: ${jsonEncode(category)}');
                  }
                }
                print('✅ Successfully parsed ${categoryList.length} service categories');
              } else {
                print('⚠️ Empty data array');
              }
            } else {
              print('❌ No content/data field in response');
            }
          } else {
            print('❌ HTTP Error: ${response.statusCode}');
            print('   Response: ${response.body}');
          }
        } catch (e) {
          print('❌ Error fetching service categories: $e');
        }
        break;
        
      case DataSourceEnum.local:
        // For local, fallback to regular categories for now
        return await _getCategoryList(false, DataSourceEnum.local);
    }
    
    return categoryList;
  }

  Future<List<CategoryModel>?> _getCategoryList(bool allCategory, DataSourceEnum source) async {
    List<CategoryModel>? categoryList;
    Map<String, String>? header = allCategory ? {
      'Content-Type': 'application/json; charset=UTF-8',
      AppConstants.localizationKey: Get.find<LocalizationController>().locale.languageCode,
    } : null;

    Map<String, String>? cacheHeader = header ?? apiClient.getHeader();

    String cacheId = AppConstants.categoryUri + Get.find<SplashController>().module!.id!.toString();

    switch(source) {
      case DataSourceEnum.client:
        Response response = await apiClient.getData(AppConstants.categoryUri, headers: header);
        if (response.statusCode == 200) {
          categoryList = [];
          response.body.forEach((category) {
            categoryList!.add(CategoryModel.fromJson(category));
          });
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body), cacheHeader);

        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          categoryList = [];
          jsonDecode(cacheResponseData).forEach((category) {
            categoryList!.add(CategoryModel.fromJson(category));
          });
        }
    }

    return categoryList;
  }

  Future<List<CategoryModel>?> _getSubCategoryList(String? parentID) async {
    List<CategoryModel>? subCategoryList;
    Response response = await apiClient.getData('${AppConstants.subCategoryUri}$parentID');
    if (response.statusCode == 200) {
      subCategoryList= [];
      response.body.forEach((category) => subCategoryList!.add(CategoryModel.fromJson(category)));
    }
    return subCategoryList;
  }

  Future<ItemModel?> _getCategoryItemList(String? categoryID, int offset, String type) async {
    ItemModel? categoryItem;
    Response response = await apiClient.getData('${AppConstants.categoryItemUri}$categoryID?limit=10&offset=$offset&type=$type');
    if (response.statusCode == 200) {
      categoryItem = ItemModel.fromJson(response.body);
    }
    return categoryItem;
  }

  Future<StoreModel?> _getCategoryStoreList(String? categoryID, int offset, String type) async {
    StoreModel? categoryStore;
    Response response = await apiClient.getData('${AppConstants.categoryStoreUri}$categoryID?limit=10&offset=$offset&type=$type');
    if (response.statusCode == 200) {
      categoryStore = StoreModel.fromJson(response.body);
    }
    return categoryStore;
  }

  @override
  Future<Response> getSearchData(String? query, String? categoryID, bool isStore, String type) async {
    return await apiClient.getData(
      '${AppConstants.searchUri}${isStore ? 'stores' : 'items'}/search?name=$query&category_id=$categoryID&type=$type&offset=1&limit=50',
    );
  }

  @override
  Future<bool> saveUserInterests(List<int?> interests) async {
    Response response = await apiClient.postData(AppConstants.interestUri, {"interest": interests});
    return (response.statusCode == 200);
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}