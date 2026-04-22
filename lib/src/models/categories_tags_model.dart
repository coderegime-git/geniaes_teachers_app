class CategoryModel {
  int? id;
  MultiLanguageModel? name;
  MultiLanguageModel? description;
  String? slug;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  CategoryModel({
    this.id,
    this.name,
    this.description,
    this.slug,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['name'] is String) {
      name = MultiLanguageModel(en: json['name'] as String);
    } else if (json['name'] is Map<String, dynamic>) {
      name = MultiLanguageModel.fromJson(json['name'] as Map<String, dynamic>);
    }

    // Same for description
    if (json['description'] is String) {
      description = MultiLanguageModel(en: json['description'] as String);
    } else if (json['description'] is Map<String, dynamic>) {
      description = MultiLanguageModel.fromJson(json['description'] as Map<String, dynamic>);
    }
    slug = json['slug'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (name != null) {
      data['name'] = name!.toJson();
    }
    if (description != null) {
      data['description'] = description!.toJson();
    }
    data['slug'] = slug;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class TagModel {
  int? id;
  String? name;
  String? slug;
  String? type;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  TagModel({
    this.id,
    this.name,
    this.slug,
    this.type,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  TagModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    type = json['type'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['type'] = type;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class MultiLanguageModel {
  String? en;
  String? hi;
  String? ar;

  MultiLanguageModel({this.en, this.hi, this.ar});

  MultiLanguageModel.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    hi = json['hi'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['en'] = en;
    data['hi'] = hi;
    data['ar'] = ar;
    return data;
  }

  // Helper to get localized name based on language code
  String? getLocalized(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return hi ?? en;
      case 'ar':
        return ar ?? en;
      default:
        return en;
    }
  }
}

class CategoryResponseModel {
  List<CategoryModel>? data;
  bool? success;
  String? message;

  CategoryResponseModel({this.data, this.success, this.message});

  CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CategoryModel>[];
      json['data'].forEach((v) {
        data!.add(CategoryModel.fromJson(v));
      });
    }
    success = json['success'];
    message = json['message'];
  }
}

class TagResponseModel {
  List<TagModel>? data;
  bool? success;
  String? message;

  TagResponseModel({this.data, this.success, this.message});

  TagResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TagModel>[];
      json['data'].forEach((v) {
        data!.add(TagModel.fromJson(v));
      });
    }
    success = json['success'];
    message = json['message'];
  }
}