
class CategoryModel {
  int? _id;
  String? _name;
  int? _parentId;
  int? _position;
  String? _createdAt;
  String? _updatedAt;
  String? _imageFullUrl;
  String? _description;
  int? _serviceCount;
  String? _uuid; // Original UUID from Demandium API

  CategoryModel(
    {int? id,
    String? name,
    int? parentId,
    int? position,
    String? createdAt,
    String? updatedAt,
    String? imageFullUrl,
    String? description,
    int? serviceCount,
    String? uuid}) {
    _id = id;
    _name = name;
    _parentId = parentId;
    _position = position;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _imageFullUrl = imageFullUrl;
    _description = description;
    _serviceCount = serviceCount;
    _uuid = uuid;
  }

  int? get id => _id;
  String? get name => _name;
  int? get parentId => _parentId;
  int? get position => _position;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get imageFullUrl => _imageFullUrl;
  String? get description => _description;
  int? get serviceCount => _serviceCount;
  String? get uuid => _uuid;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _parentId = json['parent_id'];
    _position = json['position'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _imageFullUrl = json['image_full_url'];
    _description = json['description'];
    _serviceCount = json['services_count'];
    _uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['parent_id'] = _parentId;
    data['position'] = _position;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['image_full_url'] = _imageFullUrl;
    data['description'] = _description;
    data['services_count'] = _serviceCount;
    data['uuid'] = _uuid;

    return data;
  }
}
