import 'dart:convert';

GetAllLanguagesModel getAllLanguagesFromJson(String str) =>
    GetAllLanguagesModel.fromJson(json.decode(str));
String getAllLanguagesToJson(GetAllLanguagesModel data) =>
    json.encode(data.toJson());

class GetAllLanguagesModel {
  GetAllLanguagesModel({
    List<Data>? data,
    bool? success,
    String? message,
    dynamic errors,
  }) {
    _data = data;
    _success = success;
    _message = message;
    _errors = errors;
  }

  GetAllLanguagesModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _success = json['success'];
    _message = json['message'];
    _errors = json['errors'];
  }
  List<Data>? _data;
  bool? _success;
  String? _message;
  dynamic _errors;
  GetAllLanguagesModel copyWith({
    List<Data>? data,
    bool? success,
    String? message,
    dynamic errors,
  }) =>
      GetAllLanguagesModel(
        data: data ?? _data,
        success: success ?? _success,
        message: message ?? _message,
        errors: errors ?? _errors,
      );
  List<Data>? get data => _data;
  bool? get success => _success;
  String? get message => _message;
  dynamic get errors => _errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['success'] = _success;
    map['message'] = _message;
    map['errors'] = _errors;
    return map;
  }
}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    num? id,
    String? name,
    String? description,
    String? code,
    dynamic image,
    dynamic countryCode,
    num? isDefault,
    num? isActive,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
  }) {
    _id = id;
    _name = name;
    _description = description;
    _code = code;
    _image = image;
    _countryCode = countryCode;
    _isDefault = isDefault;
    _isActive = isActive;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _code = json['code'];
    _image = json['image'];
    _countryCode = json['country_code'];
    _isDefault = json['is_default'];
    _isActive = json['is_active'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
  }
  num? _id;
  String? _name;
  String? _description;
  String? _code;
  dynamic _image;
  dynamic _countryCode;
  num? _isDefault;
  num? _isActive;
  String? _createdAt;
  String? _updatedAt;
  dynamic _deletedAt;
  Data copyWith({
    num? id,
    String? name,
    String? description,
    String? code,
    dynamic image,
    dynamic countryCode,
    num? isDefault,
    num? isActive,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
  }) =>
      Data(
        id: id ?? _id,
        name: name ?? _name,
        description: description ?? _description,
        code: code ?? _code,
        image: image ?? _image,
        countryCode: countryCode ?? _countryCode,
        isDefault: isDefault ?? _isDefault,
        isActive: isActive ?? _isActive,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        deletedAt: deletedAt ?? _deletedAt,
      );
  num? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get code => _code;
  dynamic get image => _image;
  dynamic get countryCode => _countryCode;
  num? get isDefault => _isDefault;
  num? get isActive => _isActive;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['code'] = _code;
    map['image'] = _image;
    map['country_code'] = _countryCode;
    map['is_default'] = _isDefault;
    map['is_active'] = _isActive;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    return map;
  }
}
