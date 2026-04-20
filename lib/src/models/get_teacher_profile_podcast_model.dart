import 'dart:convert';

GetTeacherProfilePodcastModel getTeacherProfilePodcastModelFromJson(
        String str) =>
    GetTeacherProfilePodcastModel.fromJson(json.decode(str));
String getTeacherProfilePodcastModelToJson(
        GetTeacherProfilePodcastModel data) =>
    json.encode(data.toJson());

class GetTeacherProfilePodcastModel {
  GetTeacherProfilePodcastModel({
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

  GetTeacherProfilePodcastModel.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
    _errors = json['errors'];
  }
  Data? _data;
  bool? _success;
  String? _message;
  dynamic _errors;
  GetTeacherProfilePodcastModel copyWith({
    Data? data,
    bool? success,
    String? message,
    dynamic errors,
  }) =>
      GetTeacherProfilePodcastModel(
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

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    List<TeacherProfilePodcastModel>? data,
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
        _data?.add(TeacherProfilePodcastModel.fromJson(v));
      });
    }
    _links = json['links'] != null ? Links.fromJson(json['links']) : null;
    _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  List<TeacherProfilePodcastModel>? _data;
  Links? _links;
  Meta? _meta;
  Data copyWith({
    List<TeacherProfilePodcastModel>? data,
    Links? links,
    Meta? meta,
  }) =>
      Data(
        data: data ?? _data,
        links: links ?? _links,
        meta: meta ?? _meta,
      );
  List<TeacherProfilePodcastModel>? get data => _data;
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

Meta metaFromJson(String str) => Meta.fromJson(json.decode(str));
String metaToJson(Meta data) => json.encode(data.toJson());

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

Links linksFromJson(String str) => Links.fromJson(json.decode(str));
String linksToJson(Links data) => json.encode(data.toJson());

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

TeacherProfilePodcastModel teacherProfilePodcastModelFromJson(String str) =>
    TeacherProfilePodcastModel.fromJson(json.decode(str));
String teacherProfilePodcastModelToJson(TeacherProfilePodcastModel data) =>
    json.encode(data.toJson());

class TeacherProfilePodcastModel {
  TeacherProfilePodcastModel({
    num? id,
    num? teacherId,
    String? teacherName,
    dynamic academyId,
    String? academyName,
    List<dynamic>? tagIds,
    List<dynamic>? tags,
    String? name,
    String? description,
    String? slug,
    num? isActive,
    num? isFeatured,
    dynamic icon,
    String? image,
    dynamic audio,
    dynamic video,
    String? linkType,
    String? fileType,
    String? fileUrl,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _teacherId = teacherId;
    _teacherName = teacherName;
    _academyId = academyId;
    _academyName = academyName;
    _tagIds = tagIds;
    _tags = tags;
    _name = name;
    _description = description;
    _slug = slug;
    _isActive = isActive;
    _isFeatured = isFeatured;
    _icon = icon;
    _image = image;
    _audio = audio;
    _video = video;
    _linkType = linkType;
    _fileType = fileType;
    _fileUrl = fileUrl;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  TeacherProfilePodcastModel.fromJson(dynamic json) {
    _id = json['id'];
    _teacherId = json['teacher_id'];
    _teacherName = json['teacher_name'];
    _academyId = json['academy_id'];
    _academyName = json['academy_name'];
    if (json['tag_ids'] != null) {
      _tagIds = [];
      json['tag_ids'].forEach((v) {
        // _tagIds?.add(Dynamic.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      _tags = [];
      json['tags'].forEach((v) {
        // _tags?.add(Dynamic.fromJson(v));
      });
    }
    _name = json['name'];
    _description = json['description'];
    _slug = json['slug'];
    _isActive = json['is_active'];
    _isFeatured = json['is_featured'];
    _icon = json['icon'];
    _image = json['image'];
    _audio = json['audio'];
    _video = json['video'];
    _linkType = json['link_type'];
    _fileType = json['file_type'];
    _fileUrl = json['file_url'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _teacherId;
  String? _teacherName;
  dynamic _academyId;
  String? _academyName;
  List<dynamic>? _tagIds;
  List<dynamic>? _tags;
  String? _name;
  String? _description;
  String? _slug;
  num? _isActive;
  num? _isFeatured;
  dynamic _icon;
  String? _image;
  dynamic _audio;
  dynamic _video;
  String? _linkType;
  String? _fileType;
  String? _fileUrl;
  String? _createdAt;
  String? _updatedAt;
  TeacherProfilePodcastModel copyWith({
    num? id,
    num? teacherId,
    String? teacherName,
    dynamic academyId,
    String? academyName,
    List<dynamic>? tagIds,
    List<dynamic>? tags,
    String? name,
    String? description,
    String? slug,
    num? isActive,
    num? isFeatured,
    dynamic icon,
    String? image,
    dynamic audio,
    dynamic video,
    String? linkType,
    String? fileType,
    String? fileUrl,
    String? createdAt,
    String? updatedAt,
  }) =>
      TeacherProfilePodcastModel(
        id: id ?? _id,
        teacherId: teacherId ?? _teacherId,
        teacherName: teacherName ?? _teacherName,
        academyId: academyId ?? _academyId,
        academyName: academyName ?? _academyName,
        tagIds: tagIds ?? _tagIds,
        tags: tags ?? _tags,
        name: name ?? _name,
        description: description ?? _description,
        slug: slug ?? _slug,
        isActive: isActive ?? _isActive,
        isFeatured: isFeatured ?? _isFeatured,
        icon: icon ?? _icon,
        image: image ?? _image,
        audio: audio ?? _audio,
        video: video ?? _video,
        linkType: linkType ?? _linkType,
        fileType: fileType ?? _fileType,
        fileUrl: fileUrl ?? _fileUrl,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get id => _id;
  num? get teacherId => _teacherId;
  String? get teacherName => _teacherName;
  dynamic get academyId => _academyId;
  String? get academyName => _academyName;
  List<dynamic>? get tagIds => _tagIds;
  List<dynamic>? get tags => _tags;
  String? get name => _name;
  String? get description => _description;
  String? get slug => _slug;
  num? get isActive => _isActive;
  num? get isFeatured => _isFeatured;
  dynamic get icon => _icon;
  String? get image => _image;
  dynamic get audio => _audio;
  dynamic get video => _video;
  String? get linkType => _linkType;
  String? get fileType => _fileType;
  String? get fileUrl => _fileUrl;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['teacher_id'] = _teacherId;
    map['teacher_name'] = _teacherName;
    map['academy_id'] = _academyId;
    map['academy_name'] = _academyName;
    if (_tagIds != null) {
      map['tag_ids'] = _tagIds?.map((v) => v.toJson()).toList();
    }
    if (_tags != null) {
      map['tags'] = _tags?.map((v) => v.toJson()).toList();
    }
    map['name'] = _name;
    map['description'] = _description;
    map['slug'] = _slug;
    map['is_active'] = _isActive;
    map['is_featured'] = _isFeatured;
    map['icon'] = _icon;
    map['image'] = _image;
    map['audio'] = _audio;
    map['video'] = _video;
    map['link_type'] = _linkType;
    map['file_type'] = _fileType;
    map['file_url'] = _fileUrl;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
