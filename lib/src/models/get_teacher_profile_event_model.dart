import 'dart:convert';

GetTeacherProfileEventModel getTeacherProfileEventModelFromJson(String str) =>
    GetTeacherProfileEventModel.fromJson(json.decode(str));

String getTeacherProfileEventModelToJson(GetTeacherProfileEventModel data) =>
    json.encode(data.toJson());

class GetTeacherProfileEventModel {
  GetTeacherProfileEventModel({
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

  GetTeacherProfileEventModel.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
    _errors = json['errors'];
  }
  Data? _data;
  bool? _success;
  String? _message;
  dynamic _errors;

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
    List<TeacherProfileEventModel>? data,
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
        _data?.add(TeacherProfileEventModel.fromJson(v));
      });
    }
    _links = json['links'] != null ? Links.fromJson(json['links']) : null;
    _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  List<TeacherProfileEventModel>? _data;
  Links? _links;
  Meta? _meta;

  List<TeacherProfileEventModel>? get data => _data;
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

  num? get currentPage => _currentPage;
  num? get lastPage => _lastPage;

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

class TeacherProfileEventModel {
  TeacherProfileEventModel({
    num? id,
    num? teacherId,
    String? name,
    dynamic description,
    String? startDate,
    String? endDate,
    String? addressLine1,
    String? addressLine2,
    String? image,
    num? isActive,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _teacherId = teacherId;
    _name = name;
    _description = description;
    _startDate = startDate;
    _endDate = endDate;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _image = image;
    _isActive = isActive;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  TeacherProfileEventModel.fromJson(dynamic json) {
    _id = json['id'];
    _teacherId = json['teacher_id'];
    _name = json['name'];
    _description = json['description']?.toString() ?? "";
    _startDate = _formatDate(json['starts_at']);
    _endDate = _formatDate(json['ends_at']);
    _addressLine1 = json['address_line_1'];
    _addressLine2 = json['address_line_2'];
    _image = json['image'];
    _isActive = json['is_active'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  String? _formatDate(String? dateStr) {
    if (dateStr == null) return null;
    try {
      DateTime dt = DateTime.parse(dateStr);
      return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateStr;
    }
  }
  num? _id;
  num? _teacherId;
  String? _name;
  dynamic _description;
  String? _startDate;
  String? _endDate;
  String? _addressLine1;
  String? _addressLine2;
  String? _image;
  num? _isActive;
  String? _createdAt;
  String? _updatedAt;

  num? get id => _id;
  String? get name => _name;
  dynamic get description => _description;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get image => _image;
  num? get isActive => _isActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['teacher_id'] = _teacherId;
    map['name'] = _name;
    map['description'] = _description;
    map['starts_at'] = _startDate;
    map['ends_at'] = _endDate;
    map['address_line_1'] = _addressLine1;
    map['address_line_2'] = _addressLine2;
    map['image'] = _image;
    map['is_active'] = _isActive;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
