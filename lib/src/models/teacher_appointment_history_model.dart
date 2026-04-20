import 'dart:convert';

GetTeacherAppointmentHistoryModel getTeacherAppointmentHistoryModelFromJson(
        String str) =>
    GetTeacherAppointmentHistoryModel.fromJson(json.decode(str));
String getTeacherAppointmentHistoryModelToJson(
        GetTeacherAppointmentHistoryModel data) =>
    json.encode(data.toJson());

class GetTeacherAppointmentHistoryModel {
  GetTeacherAppointmentHistoryModel({
    GetTeacherAppointmentHistoryDataModel? data,
    bool? success,
    String? message,
    dynamic errors,
  }) {
    _data = data;
    _success = success;
    _message = message;
    _errors = errors;
  }

  GetTeacherAppointmentHistoryModel.fromJson(dynamic json) {
    _data = json['data'] != null
        ? GetTeacherAppointmentHistoryDataModel.fromJson(json['data'])
        : null;
    _success = json['success'];
    _message = json['message'];
    _errors = json['errors'];
  }
  GetTeacherAppointmentHistoryDataModel? _data;
  bool? _success;
  String? _message;
  dynamic _errors;
  GetTeacherAppointmentHistoryModel copyWith({
    GetTeacherAppointmentHistoryDataModel? data,
    bool? success,
    String? message,
    dynamic errors,
  }) =>
      GetTeacherAppointmentHistoryModel(
        data: data ?? _data,
        success: success ?? _success,
        message: message ?? _message,
        errors: errors ?? _errors,
      );
  GetTeacherAppointmentHistoryDataModel? get data => _data;
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

GetTeacherAppointmentHistoryDataModel dataFromJson(String str) =>
    GetTeacherAppointmentHistoryDataModel.fromJson(json.decode(str));
String dataToJson(GetTeacherAppointmentHistoryDataModel data) =>
    json.encode(data.toJson());

class GetTeacherAppointmentHistoryDataModel {
  GetTeacherAppointmentHistoryDataModel({
    List<TeacherAppointmentHistoryModel>? data,
    Links? links,
    Meta? meta,
  }) {
    _data = data;
    _links = links;
    _meta = meta;
  }

  GetTeacherAppointmentHistoryDataModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(TeacherAppointmentHistoryModel.fromJson(v));
      });
    }
    _links = json['links'] != null ? Links.fromJson(json['links']) : null;
    _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  List<TeacherAppointmentHistoryModel>? _data;
  Links? _links;
  Meta? _meta;
  GetTeacherAppointmentHistoryDataModel copyWith({
    List<TeacherAppointmentHistoryModel>? data,
    Links? links,
    Meta? meta,
  }) =>
      GetTeacherAppointmentHistoryDataModel(
        data: data ?? _data,
        links: links ?? _links,
        meta: meta ?? _meta,
      );
  List<TeacherAppointmentHistoryModel>? get data => _data;
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

MetaLinks metaLinksFromJson(String str) => MetaLinks.fromJson(json.decode(str));
String metaLinksToJson(MetaLinks data) => json.encode(data.toJson());

class MetaLinks {
  MetaLinks({
    dynamic url,
    String? label,
    bool? active,
  }) {
    _url = url;
    _label = label;
    _active = active;
  }

  MetaLinks.fromJson(dynamic json) {
    _url = json['url'];
    _label = json['label'];
    _active = json['active'];
  }
  dynamic _url;
  String? _label;
  bool? _active;
  MetaLinks copyWith({
    dynamic url,
    String? label,
    bool? active,
  }) =>
      MetaLinks(
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

Links linksFromJson(String str) => Links.fromJson(json.decode(str));
String linksToJson(Links data) => json.encode(data.toJson());

class Links {
  Links({
    String? first,
    String? last,
    dynamic prev,
    dynamic next,
  }) {
    _first = first;
    _last = last;
    _prev = prev;
    _next = next;
  }

  Links.fromJson(dynamic json) {
    _first = json['first'];
    _last = json['last'];
    _prev = json['prev'];
    _next = json['next'];
  }
  String? _first;
  String? _last;
  dynamic _prev;
  dynamic _next;
  Links copyWith({
    String? first,
    String? last,
    dynamic prev,
    dynamic next,
  }) =>
      Links(
        first: first ?? _first,
        last: last ?? _last,
        prev: prev ?? _prev,
        next: next ?? _next,
      );
  String? get first => _first;
  String? get last => _last;
  dynamic get prev => _prev;
  dynamic get next => _next;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first'] = _first;
    map['last'] = _last;
    map['prev'] = _prev;
    map['next'] = _next;
    return map;
  }
}

TeacherAppointmentHistoryModel teacherAppointmentHistoryModelFromJson(
        String str) =>
    TeacherAppointmentHistoryModel.fromJson(json.decode(str));
String teacherAppointmentHistoryModelToJson(
        TeacherAppointmentHistoryModel data) =>
    json.encode(data.toJson());

class TeacherAppointmentHistoryModel {
  TeacherAppointmentHistoryModel({
    num? id,
    num? studentId,
    String? studentName,
    String? studentImage,
    String? appointmentStatusName,
    String? appointmentTypeName,
    num? isScheduleRequired,
    num? teacherId,
    String? teacherName,
    String? teacherImage,
    dynamic academyId,
    dynamic academyName,
    dynamic academyImage,
    String? date,
    String? startTime,
    String? endTime,
    num? fee,
    num? isPaid,
    num? appointmentTypeId,
    String? question,
    dynamic attachmentUrl,
    num? appointmentStatusCode,
    List<Messages>? messages,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _studentId = studentId;
    _studentName = studentName;
    _studentImage = studentImage;
    _appointmentStatusName = appointmentStatusName;
    _appointmentTypeName = appointmentTypeName;
    _isScheduleRequired = isScheduleRequired;
    _teacherId = teacherId;
    _teacherName = teacherName;
    _teacherImage = teacherImage;
    _academyId = academyId;
    _academyName = academyName;
    _academyImage = academyImage;
    _date = date;
    _startTime = startTime;
    _endTime = endTime;
    _fee = fee;
    _isPaid = isPaid;
    _appointmentTypeId = appointmentTypeId;
    _question = question;
    _attachmentUrl = attachmentUrl;
    _appointmentStatusCode = appointmentStatusCode;
    _messages = messages;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  TeacherAppointmentHistoryModel.fromJson(dynamic json) {
    _id = json['id'];
    _studentId = json['student_id'];
    _studentName = json['student_name'];
    _studentImage = json['student_image'];
    _appointmentStatusName = json['appointment_status_name'];
    _appointmentTypeName = json['appointment_type_name'];
    _isScheduleRequired = json['is_schedule_required'];
    _teacherId = json['teacher_id'];
    _teacherName = json['teacher_name'];
    _teacherImage = json['teacher_image'];
    _academyId = json['academy_id'];
    _academyName = json['academy_name'];
    _academyImage = json['academy_image'];
    _date = json['date'];
    _startTime = json['start_time'];
    _endTime = json['end_time'];
    _fee = json['fee'];
    _isPaid = json['is_paid'];
    _appointmentTypeId = json['appointment_type_id'];
    _question = json['question'];
    _attachmentUrl = json['attachment_url'];
    _appointmentStatusCode = json['appointment_status_code'];
    if (json['messages'] != null) {
      _messages = [];
      json['messages'].forEach((v) {
        _messages?.add(Messages.fromJson(v));
      });
    }
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _studentId;
  String? _studentName;
  String? _studentImage;
  String? _appointmentStatusName;
  String? _appointmentTypeName;
  num? _isScheduleRequired;
  num? _teacherId;
  String? _teacherName;
  String? _teacherImage;
  dynamic _academyId;
  dynamic _academyName;
  dynamic _academyImage;
  String? _date;
  String? _startTime;
  String? _endTime;
  num? _fee;
  num? _isPaid;
  num? _appointmentTypeId;
  String? _question;
  dynamic _attachmentUrl;
  num? _appointmentStatusCode;
  List<Messages>? _messages;
  String? _createdAt;
  String? _updatedAt;
  TeacherAppointmentHistoryModel copyWith({
    num? id,
    num? studentId,
    String? studentName,
    String? studentImage,
    String? appointmentStatusName,
    String? appointmentTypeName,
    num? isScheduleRequired,
    num? teacherId,
    String? teacherName,
    String? teacherImage,
    dynamic academyId,
    dynamic academyName,
    dynamic academyImage,
    String? date,
    String? startTime,
    String? endTime,
    num? fee,
    num? isPaid,
    num? appointmentTypeId,
    String? question,
    dynamic attachmentUrl,
    num? appointmentStatusCode,
    List<Messages>? messages,
    String? createdAt,
    String? updatedAt,
  }) =>
      TeacherAppointmentHistoryModel(
        id: id ?? _id,
        studentId: studentId ?? _studentId,
        studentName: studentName ?? _studentName,
        studentImage: studentImage ?? _studentImage,
        appointmentStatusName: appointmentStatusName ?? _appointmentStatusName,
        appointmentTypeName: appointmentTypeName ?? _appointmentTypeName,
        isScheduleRequired: isScheduleRequired ?? _isScheduleRequired,
        teacherId: teacherId ?? _teacherId,
        teacherName: teacherName ?? _teacherName,
        teacherImage: teacherImage ?? _teacherImage,
        academyId: academyId ?? _academyId,
        academyName: academyName ?? _academyName,
        academyImage: academyImage ?? _academyImage,
        date: date ?? _date,
        startTime: startTime ?? _startTime,
        endTime: endTime ?? _endTime,
        fee: fee ?? _fee,
        isPaid: isPaid ?? _isPaid,
        appointmentTypeId: appointmentTypeId ?? _appointmentTypeId,
        question: question ?? _question,
        attachmentUrl: attachmentUrl ?? _attachmentUrl,
        appointmentStatusCode: appointmentStatusCode ?? _appointmentStatusCode,
        messages: messages ?? _messages,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get id => _id;
  num? get studentId => _studentId;
  String? get studentName => _studentName;
  String? get studentImage => _studentImage;
  String? get appointmentStatusName => _appointmentStatusName;
  String? get appointmentTypeName => _appointmentTypeName;
  num? get isScheduleRequired => _isScheduleRequired;
  num? get teacherId => _teacherId;
  String? get teacherName => _teacherName;
  String? get teacherImage => _teacherImage;
  dynamic get academyId => _academyId;
  dynamic get academyName => _academyName;
  dynamic get academyImage => _academyImage;
  String? get date => _date;
  String? get startTime => _startTime;
  String? get endTime => _endTime;
  num? get fee => _fee;
  num? get isPaid => _isPaid;
  num? get appointmentTypeId => _appointmentTypeId;
  String? get question => _question;
  dynamic get attachmentUrl => _attachmentUrl;
  num? get appointmentStatusCode => _appointmentStatusCode;
  List<Messages>? get messages => _messages;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['student_id'] = _studentId;
    map['student_name'] = _studentName;
    map['student_image'] = _studentImage;
    map['appointment_status_name'] = _appointmentStatusName;
    map['appointment_type_name'] = _appointmentTypeName;
    map['is_schedule_required'] = _isScheduleRequired;
    map['teacher_id'] = _teacherId;
    map['teacher_name'] = _teacherName;
    map['teacher_image'] = _teacherImage;
    map['academy_id'] = _academyId;
    map['academy_name'] = _academyName;
    map['academy_image'] = _academyImage;
    map['date'] = _date;
    map['start_time'] = _startTime;
    map['end_time'] = _endTime;
    map['fee'] = _fee;
    map['is_paid'] = _isPaid;
    map['appointment_type_id'] = _appointmentTypeId;
    map['question'] = _question;
    map['attachment_url'] = _attachmentUrl;
    map['appointment_status_code'] = _appointmentStatusCode;
    if (_messages != null) {
      map['messages'] = _messages?.map((v) => v.toJson()).toList();
    }
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}

Messages messagesFromJson(String str) => Messages.fromJson(json.decode(str));
String messagesToJson(Messages data) => json.encode(data.toJson());

class Messages {
  Messages({
    num? id,
    String? message,
    num? appointmentId,
    num? senderId,
    String? senderType,
    String? recieverId,
    String? recieverType,
    dynamic attachmentUrl,
    bool? isAttachment,
    bool? isSeen,
    dynamic seenAt,
    bool? isDelivered,
    dynamic deliveredAt,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _message = message;
    _appointmentId = appointmentId;
    _senderId = senderId;
    _senderType = senderType;
    _recieverId = recieverId;
    _recieverType = recieverType;
    _attachmentUrl = attachmentUrl;
    _isAttachment = isAttachment;
    _isSeen = isSeen;
    _seenAt = seenAt;
    _isDelivered = isDelivered;
    _deliveredAt = deliveredAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Messages.fromJson(dynamic json) {
    _id = json['id'];
    _message = json['message'];
    _appointmentId = json['appointment_id'];
    _senderId = json['sender_id'];
    _senderType = json['sender_type'];
    _recieverId = json['reciever_id'];
    _recieverType = json['reciever_type'];
    _attachmentUrl = json['attachment_url'];
    _isAttachment = json['is_attachment'];
    _isSeen = json['is_seen'];
    _seenAt = json['seen_at'];
    _isDelivered = json['is_delivered'];
    _deliveredAt = json['delivered_at'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  String? _message;
  num? _appointmentId;
  num? _senderId;
  String? _senderType;
  String? _recieverId;
  String? _recieverType;
  dynamic _attachmentUrl;
  bool? _isAttachment;
  bool? _isSeen;
  dynamic _seenAt;
  bool? _isDelivered;
  dynamic _deliveredAt;
  String? _createdAt;
  String? _updatedAt;
  Messages copyWith({
    num? id,
    String? message,
    num? appointmentId,
    num? senderId,
    String? senderType,
    String? recieverId,
    String? recieverType,
    dynamic attachmentUrl,
    bool? isAttachment,
    bool? isSeen,
    dynamic seenAt,
    bool? isDelivered,
    dynamic deliveredAt,
    String? createdAt,
    String? updatedAt,
  }) =>
      Messages(
        id: id ?? _id,
        message: message ?? _message,
        appointmentId: appointmentId ?? _appointmentId,
        senderId: senderId ?? _senderId,
        senderType: senderType ?? _senderType,
        recieverId: recieverId ?? _recieverId,
        recieverType: recieverType ?? _recieverType,
        attachmentUrl: attachmentUrl ?? _attachmentUrl,
        isAttachment: isAttachment ?? _isAttachment,
        isSeen: isSeen ?? _isSeen,
        seenAt: seenAt ?? _seenAt,
        isDelivered: isDelivered ?? _isDelivered,
        deliveredAt: deliveredAt ?? _deliveredAt,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get id => _id;
  String? get message => _message;
  num? get appointmentId => _appointmentId;
  num? get senderId => _senderId;
  String? get senderType => _senderType;
  String? get recieverId => _recieverId;
  String? get recieverType => _recieverType;
  dynamic get attachmentUrl => _attachmentUrl;
  bool? get isAttachment => _isAttachment;
  bool? get isSeen => _isSeen;
  dynamic get seenAt => _seenAt;
  bool? get isDelivered => _isDelivered;
  dynamic get deliveredAt => _deliveredAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['message'] = _message;
    map['appointment_id'] = _appointmentId;
    map['sender_id'] = _senderId;
    map['sender_type'] = _senderType;
    map['reciever_id'] = _recieverId;
    map['reciever_type'] = _recieverType;
    map['attachment_url'] = _attachmentUrl;
    map['is_attachment'] = _isAttachment;
    map['is_seen'] = _isSeen;
    map['seen_at'] = _seenAt;
    map['is_delivered'] = _isDelivered;
    map['delivered_at'] = _deliveredAt;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
