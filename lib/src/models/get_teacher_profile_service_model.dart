import 'dart:convert';

GetTeacherProfileServiceModel getTeacherProfileServiceModelFromJson(String str) =>
    GetTeacherProfileServiceModel.fromJson(json.decode(str));

String getTeacherProfileServiceModelToJson(GetTeacherProfileServiceModel data) =>
    json.encode(data.toJson());

class GetTeacherProfileServiceModel {
  GetTeacherProfileServiceModel({
    Data? data,
    bool? success,
    String? message,
    dynamic errors,
  }) {
    _data = data;
    _success = success;
    _message = message;
    _errors = errors;
  }

  GetTeacherProfileServiceModel.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
    _errors = json['errors'];
  }
  Data? _data;
  bool? _success;
  String? _message;
  dynamic _errors;
  GetTeacherProfileServiceModel copyWith({
    Data? data,
    bool? success,
    String? message,
    dynamic errors,
  }) =>
      GetTeacherProfileServiceModel(
        data: data ?? _data,
        success: success ?? _success,
        message: message ?? _message,
        errors: errors ?? _errors,
      );
  Data? get data => _data;
  bool? get success => _success;
  String? get message => _message;
  dynamic get errors => _errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['success'] = _success;
    map['message'] = _message;
    map['errors'] = _errors;
    return map;
  }
}

class Data {
  Data({
    List<TeacherProfileServiceModel>? data,
    Links? links,
    Meta? meta,
  }) {
    _data = data;
    _links = links;
    _meta = meta;
  }

  Data.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(TeacherProfileServiceModel.fromJson(v));
      });
    }
    _links = json['links'] != null ? Links.fromJson(json['links']) : null;
    _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  List<TeacherProfileServiceModel>? _data;
  Links? _links;
  Meta? _meta;
  Data copyWith({
    List<TeacherProfileServiceModel>? data,
    Links? links,
    Meta? meta,
  }) =>
      Data(
        data: data ?? _data,
        links: links ?? _links,
        meta: meta ?? _meta,
      );
  List<TeacherProfileServiceModel>? get data => _data;
  Links? get links => _links;
  Meta? get meta => _meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_links != null) {
      map['links'] = _links?.toJson();
    }
    if (_meta != null) {
      map['meta'] = _meta?.toJson();
    }
    return map;
  }
}

class Meta {
  Meta({
    num? currentPage,
    num? from,
    num? lastPage,
    List<Links>? links,
    String? path,
    num? perPage,
    num? to,
    num? total,
  }) {
    _currentPage = currentPage;
    _from = from;
    _lastPage = lastPage;
    _links = links;
    _path = path;
    _perPage = perPage;
    _to = to;
    _total = total;
  }

  Meta.fromJson(dynamic json) {
    _currentPage = json['current_page'];
    _from = json['from'];
    _lastPage = json['last_page'];
    if (json['links'] != null) {
      _links = [];
      json['links'].forEach((v) {
        _links?.add(Links.fromJson(v));
      });
    }
    _path = json['path'];
    _perPage = json['per_page'];
    _to = json['to'];
    _total = json['total'];
  }
  num? _currentPage;
  num? _from;
  num? _lastPage;
  List<Links>? _links;
  String? _path;
  num? _perPage;
  num? _to;
  num? _total;
  Meta copyWith({
    num? currentPage,
    num? from,
    num? lastPage,
    List<Links>? links,
    String? path,
    num? perPage,
    num? to,
    num? total,
  }) =>
      Meta(
        currentPage: currentPage ?? _currentPage,
        from: from ?? _from,
        lastPage: lastPage ?? _lastPage,
        links: links ?? _links,
        path: path ?? _path,
        perPage: perPage ?? _perPage,
        to: to ?? _to,
        total: total ?? _total,
      );
  num? get currentPage => _currentPage;
  num? get from => _from;
  num? get lastPage => _lastPage;
  List<Links>? get links => _links;
  String? get path => _path;
  num? get perPage => _perPage;
  num? get to => _to;
  num? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = _currentPage;
    map['from'] = _from;
    map['last_page'] = _lastPage;
    if (_links != null) {
      map['links'] = _links?.map((v) => v.toJson()).toList();
    }
    map['path'] = _path;
    map['per_page'] = _perPage;
    map['to'] = _to;
    map['total'] = _total;
    return map;
  }
}

class Links {
  Links({
    dynamic url,
    String? label,
    bool? active,
  }) {
    _url = url;
    _label = label;
    _active = active;
  }

  Links.fromJson(dynamic json) {
    _url = json['url'];
    _label = json['label'];
    _active = json['active'];
  }
  dynamic _url;
  String? _label;
  bool? _active;
  Links copyWith({
    dynamic url,
    String? label,
    bool? active,
  }) =>
      Links(
        url: url ?? _url,
        label: label ?? _label,
        active: active ?? _active,
      );
  dynamic get url => _url;
  String? get label => _label;
  bool? get active => _active;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = _url;
    map['label'] = _label;
    map['active'] = _active;
    return map;
  }
}

class TeacherProfileServiceModel {
  TeacherProfileServiceModel({
    num? id,
    num? teacherId,
    String? name,
    String? description,
    String? price,
    String? image,
    num? isActive,
    num? serviceCategoryId,
    List<dynamic>? tags,
  }) {
    _id = id;
    _teacherId = teacherId;
    _name = name;
    _description = description;
    _price = price;
    _image = image;
    _isActive = isActive;
    _serviceCategoryId = serviceCategoryId;
    _tags = tags;
  }

  TeacherProfileServiceModel.fromJson(dynamic json) {
    _id = json['id'];
    _teacherId = json['teacher_id'];
    _name = json['name'];
    _description = json['description'];
    _price = json['price']?.toString();
    _image = json['image'];
    _isActive = json['is_active'];
    _serviceCategoryId = json['service_category_id'];
    _tags = json['tags'];
  }
  num? _id;
  num? _teacherId;
  String? _name;
  String? _description;
  String? _price;
  String? _image;
  num? _isActive;
  num? _serviceCategoryId;
  List<dynamic>? _tags;

  TeacherProfileServiceModel copyWith({
    num? id,
    num? teacherId,
    String? name,
    String? description,
    String? price,
    String? image,
    num? isActive,
    num? serviceCategoryId,
    List<dynamic>? tags,
  }) =>
      TeacherProfileServiceModel(
        id: id ?? _id,
        teacherId: teacherId ?? _teacherId,
        name: name ?? _name,
        description: description ?? _description,
        price: price ?? _price,
        image: image ?? _image,
        isActive: isActive ?? _isActive,
        serviceCategoryId: serviceCategoryId ?? _serviceCategoryId,
        tags: tags ?? _tags,
      );
  num? get id => _id;
  num? get teacherId => _teacherId;
  String? get name => _name;
  String? get description => _description;
  String? get price => _price;
  String? get image => _image;
  num? get isActive => _isActive;
  num? get serviceCategoryId => _serviceCategoryId;
  List<dynamic>? get tags => _tags;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['teacher_id'] = _teacherId;
    map['name'] = _name;
    map['description'] = _description;
    map['price'] = _price;
    map['image'] = _image;
    map['is_active'] = _isActive;
    map['service_category_id'] = _serviceCategoryId;
    map['tags'] = _tags;
    return map;
  }
}
